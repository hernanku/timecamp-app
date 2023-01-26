current_dir = $(shell pwd)
db_container_name = timecamp-db
localhost_ip ?= 192.168.12.222
mongo_db_uri = 'mongodb://${localhost_ip}:27017/'
backend_container_name = timecamp-backend
frontend_container_name = timecamp-frontend
backend_dir = ${current_dir}/backend
frontend_dir = ${current_dir}/frontend
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


all-down-docker:
		docker container stop ${frontend_container_name} && \
			docker container stop ${backend_container_name} && \
			docker container stop ${db_container_name} 
