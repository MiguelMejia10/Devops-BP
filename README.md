# Demo Devops Java

This is a simple application to be used in the technical test of DevOps.

## Getting Started

### Prerequisites

- Java Version 17
- Spring Boot 3.0.5
- Maven

### Installation

Clone this repo.

```bash
git clone https://bitbucket.org/devsu/demo-devops-java.git
```

### Database

The database is generated as a file in the main path when the project is first run, and its name is `test.mv.db`.

Consider giving access permissions to the file for proper functioning.

## Usage

To run tests you can use this command.

```bash
mvn clean test
```

To run locally the project you can use this command.

```bash
mvn spring-boot:run
```

Open http://127.0.0.1:8000/api/swagger-ui.html with your browser to see the result.

### Features

These services can perform,

#### Create User

To create a user, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: POST
```

```json
{
    "dni": "dni",
    "name": "name"
}
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "errors": [
        "error"
    ]
}
```

#### Get Users

To get all users, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
[
    {
        "id": 1,
        "dni": "dni",
        "name": "name"
    }
]
```

#### Get User

To get an user, the endpoint **/api/users/<id>** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the user id does not exist, we will receive status 404 and the following message:

```json
{
    "errors": [
        "User not found: <id>"
    ]
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "errors": [
        "error"
    ]
}
```

## License

Copyright © 2023 Devsu. All rights reserved.

## CI/CD & DevOps Additions

- **Dockerfile** multi-stage con usuario no root y healthcheck.
- **GitHub Actions** workflow `ci-cd.yml`: build, tests, static analysis, coverage, build+push, Trivy (opcional).
- **Kubernetes** manifests en `k8s/`: Namespace, ConfigMap, Secret, Deployment (2 réplicas), Service, Ingress.
- **Scripts** en `scripts/` para renderizar imagen y desplegar localmente.
- **Makefile** con atajos.

### Ejecutar local con Minikube
```bash
minikube start
minikube addons enable ingress
docker build -t <usuario>/demo-devops-java:local .
export IMAGE_TAG=local REGISTRY=docker.io/<usuario>
./scripts/render_k8s.sh
./scripts/deploy_local.sh
minikube ip  # mapear demo.local en /etc/hosts si usas Ingress
curl http://demo.local/api/users
```

### Pipeline
- Configura secrets `DOCKER_USERNAME` y `DOCKER_PASSWORD`.
- El workflow publica dos tags: `latest` y `${GITHUB_SHA}`.
