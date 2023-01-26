## Getting Started
Application project used to test different devops possibilities
- github actions
- gitlab pipelines

### Setup
Clone Git repository
```sh

```

## Local Testing
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

#### docker 
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



