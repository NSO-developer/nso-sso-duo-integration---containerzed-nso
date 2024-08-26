VER=6.3.1
ENABLED_SERVICES= BUILD-NSO-PKGS NSO-1
ARCH=arm64
PKG_DIR =/opt/ncs/ncs-${VER}/packages/auth/cisco-nso-saml2-auth

.PHONY: all
all: build start saml2_pkg

.PHONY: end
end: stop clean

.PHONY: clean
clean: deep_clean
	rm cisco-nso-saml2-auth.xml || echo "Removing old keys next"
	rm -rf keys  __pycache__ || echo "No keys to remove"

saml2_pkg: packages/cisco-nso-saml2-auth \
			compile_packages 
			docker exec nso1 bash -c 'echo "packages reload" | ncs_cli -Cu admin'
			./keys.gen
			./gen-smal2-auth-xml.sh $(DUO_URL) $(NSO_URL)
			docker exec nso1 ncs_load -l -m nso/run/cisco-nso-saml2-auth.xml

packages/cisco-nso-saml2-auth:
	ls packages/nso-sso-duo-integration-package/ > /dev/null 2>&1 || \
	(cd packages/ ; git clone https://github.com/NSO-developer/nso-sso-duo-integration-package.git)
	cp -a packages/nso-sso-duo-integration-package NSO-vol/NSO1/run/$@

build:
	docker load -i ./images/nso-${VER}.container-image-dev.linux.${ARCH}.tar.gz
	docker load -i ./images/nso-${VER}.container-image-prod.linux.${ARCH}.tar.gz
	./prepare_build.sh $(VER)
	docker run -d  --name nso-prod -e ADMIN_USERNAME=admin -e ADMIN_PASSWORD=admin -e EXTRA_ARGS=--with-package-reload-force  -v ./NSO-log-vol/NSO1:/log mod-nso-prod:${VER}
	bash check_nso1_status.sh
	docker exec nso-prod bash -c 'chmod 777 -R /nso/*'
	docker exec nso-prod bash -c 'chmod 777 -R /log/*'
	docker cp nso-prod:/nso/ NSO-vol/
	mv NSO-vol/nso NSO-vol/NSO1
	rm -rf NSO-vol/nso
	docker stop nso-prod && docker rm nso-prod
	cp util/Makefile NSO-vol/NSO1/run/packages/
	cp config/ncs.conf NSO-vol/NSO1/etc/
	
deep_clean: clean_log clean_run clean_docker

clean_docker: 
	-docker ps -a | grep -E 'nso-prod|nso-dev' | cut -d' ' -f1 | xargs docker container stop | xargs docker rm

clean_run:
	rm -rf ./NSO-vol/*

clean_log:
	rm -rf ./NSO-log-vol/*/*

clean_cdb:
	rm  ./NSO-vol/*/run/cdb/*.cdb

start:
	export VER=${VER} ; docker compose up ${ENABLED_SERVICES} -d
	bash check_status.sh

stop:
	export VER=${VER} ;docker compose down  ${ENABLED_SERVICES}

compile_packages:
	docker exec -it nso-dev make all -C nso1/run/packages

cli-c:
	docker exec -it nso1 ncs_cli -C -u admin

cli-j:
	docker exec -it nso1 ncs_cli -J -u admin