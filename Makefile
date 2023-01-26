current_dir = $(shell pwd)
docker_registry ?= hernanku
db_container_name = timecamp-db
localhost_ip ?= 192.168.12.222
mongo_db_uri = 'mongodb://${localhost_ip}:27017/'
backend_container_name = timecamp-backend
backend_container_tag ?= tag-this
frontend_container_name = timecamp-frontend
frontend_container_tag ?= tag-this
backend_dir = ${current_dir}/timecamp-backend
frontend_dir = ${current_dir}/timecamp-frontend
backend_url = http://${localhost_ip}:9000/


# Mongo db
db-up-docker:
	docker run -d -ti --rm --name ${db_container_name} \
		-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
		-e MONGO_INITDB_ROOT_PASSWORD=secret \
		-p 27017:27017 \
		mongo:6 

db-down-docker:
	docker container stop ${db_container_name}

# Backend
backend-docker-build:
	docker build -f ${backend_dir}/Dockerfile -t ${backend_container_name}:latest

backend-docker-build-tag:
	docker build -f ${backend_dir}/Dockerfile -t ${backend_container_name}:${backend_container_tag}

backend-docker-push:
	docker push ${docker_registry}:latest

backend-docker-push-tag:
	docker push ${docker_registry}:${backend_container_tag}

backend-docker-build-push:
	docker build -f ${backend_dir}/Dockerfile -t ${backend_container_name}:latest && \
		docker build -f ${backend_dir}/Dockerfile -t ${backend_container_name}:${backend_container_tag} && \
		docker push ${docker_registry}:latest && \
		docker push ${docker_registry}:${backend_container_tag}

backend-up-docker:
	docker run -d --rm -ti --name ${backend_container_name} \
		-v ${backend_dir}:/home/node/app \
		-w /home/node/app \
		-e MONGO_URL=${mongo_db_uri} \
		-e PORT=9000 \
		-p 9000:9000 \
		node:16 \
		/bin/sh -c "npm install && npm start"

backend-down-docker:
	docker container stop ${backend_container_name}

# Frontend
frontend-up-docker:
	docker run -d --rm -ti --name ${frontend_container_name} \
		-v ${frontend_dir}:/home/node/app \
		-w /home/node/app \
		-e BACKEND_URL=${backend_url} \
		-e PORT=4000 \
		-p 4000:4000 \
		node:16 \
		/bin/sh -c "npm install && npm start"

frontend-down-docker:
	docker container stop ${frontend_container_name}

## docker build and push for ci-cd
frontend-docker-build:
	docker build -f ${frontend_dir}/Dockerfile -t ${frontend_container_name}:latest

frontend-docker-build-tag:
	docker build -f ${frontend_dir}/Dockerfile -t ${frontend_container_name}:${frontend_container_tag}

frontend-docker-push:
	docker push ${docker_registry}:latest

frontend-docker-push-tag:
	docker push ${docker_registry}:${frontend_container_tag}

frontend-docker-build-push:
	docker build -f ${frontend_dir}/Dockerfile -t ${frontend_container_name}:latest && \
		docker build -f ${frontend_dir}/Dockerfile -t ${frontend_container_name}:${frontend_container_tag} && \
		docker push ${docker_registry}:latest && \
		docker push ${docker_registry}:${frontend_container_tag}

all-down-docker:
		docker container stop ${frontend_container_name} && \
			docker container stop ${backend_container_name} && \
			docker container stop ${db_container_name} 
