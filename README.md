# Getting Started
Application project used to test different devops possibilities  
- github actions
- gitlab pipelines

## Setup
Clone Git repository
```sh
git clone https://github.com/hernanku/timecamp-app.git
```

## Local Testing
**_Note:_** Most of the commands have a `make` wrapper command that can be run from the project root directory
### Prerequisite
Run a MongoDB

#### docker 
```sh
docker run -d -ti --rm --name timecamp-db \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	-p 27017:27017 \
	mongo:6 
```

### Backend
#### Local server
- Change directory to the `timecamp-backend` directory 
```sh
cd timecamp-backend
```

- Run npm install
```sh
npm install
```

- Run local development server
```sh
MONGO_URL=<mongodb_url> npm start
```

#### docker run
```sh
docker run -d --rm -ti --name timecamp-backend \
	-v timecamp-backend:/home/node/app \
	-w /home/node/app \
	-e MONGO_URL=<mongodb_url> \
	-e PORT=9000 \
	-p 9000:9000 \
	node:16 \
	/bin/sh -c "npm install && npm start"
```

#### docker build and push
- latest tag
```sh
docker build -f timecamp-backend/Dockerfile -t timecamp-backend:latest
```
```sh
docker push <docker_registry>:latest
```
**_Note:_** Be sure to have access to your docker registry, if it's a private repo.

- specific tag
```sh
docker build -f timecamp-backend/Dockerfile -t timecamp-backend:<specify_tag>
```
```sh
docker push <docker_registry>:<specify_tag>
```
**_Note:_** Be sure to have access to your docker registry, if it's a private repo.



### Frontend
- Change directory to the `timecamp-frontend` directory 
```sh
cd timecamp-frontend
```

- Run npm install
```sh
npm install
```

- Run local development server
```sh
BACKEND_URL=http://<backend_server_host>:9000/ npm start
```
#### docker 
```sh
docker run -d --rm -ti --name timecamp-frontend \
	-v timecamp-frontend:/home/node/app \
	-w /home/node/app \
	-e BACKEND_URL=http://<backend_server_host>:9000/ \
	-e PORT=4000 \
	-p 4000:4000 \
	node:16 \
	/bin/sh -c "npm install && npm start"
```

#### docker build and push
- latest tag
```sh
docker build -f timecamp-frontend/Dockerfile -t timecamp-frontend:latest
```
```sh
docker push <docker_registry>:latest
```
**_Note:_** Be sure to have access to your docker registry, if it's a private repo.

- specific tag
```sh
docker build -f timecamp-frontend/Dockerfile -t timecamp-frontend:<specify_tag>
```
```sh
docker push <docker_registry>:<specify_tag>
```
**_Note:_** Be sure to have access to your docker registry, if it's a private repo.




