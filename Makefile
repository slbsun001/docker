.PHONY: build start

include env_make
NS = mysql
VERSION ?= latest

REPO = **User Specific***
NAME =  **User Specific***
INSTANCE = ${REPO}

.PHONY: build push shell run start stop rm logs release clean mysql bash

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)

shell:
	#docker run --rm -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash
	docker run --rm -i -t $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

run:
	docker run --rm $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	-docker stop $(NAME)-$(INSTANCE)

restart:
	docker restart $(NAME)-$(INSTANCE)

rm: stop
	-docker rm -v $(NAME)-$(INSTANCE)

logs: 
	-docker logs $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build

clean: rm
	-docker rmi -f ${NS}/${REPO}:${VERSION}

mysql:
	docker exec -ti ${NAME}-${INSTANCE} /usr/bin/mysqladmin --defaults-extra-file=/docker-entrypoint-initdb.d/.my.cnf --silent --wait=30 ping
	docker exec -ti ${NAME}-${INSTANCE} /usr/bin/mysql --defaults-extra-file=/docker-entrypoint-initdb.d/.my.cnf

bash:
	docker exec -ti ${NAME}-${INSTANCE} /bin/bash 
