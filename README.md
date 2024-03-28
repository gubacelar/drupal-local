# Drupal Docker Environment

This project sets up a Docker environment for Drupal development, including MySQL for the database, Nginx as the web server, and Certbot for SSL certificates.

## Project Structure

- `docker-compose.yml`: Defines the services, networks, and volumes for the project.
- `.env`: A file for setting essential environment variables for container configuration. This file should be created based on the instructions below and is not included in the repository for security reasons.
- `nginx-conf/`: Directory containing the Nginx configuration (`nginx.conf`) to serve the Drupal application.
- `drupal/`: Directory where Drupal will be installed and its files persisted.

## Prerequisites

- Docker and Docker Compose installed on your machine.
- Create a `.env` file in the project's root directory with the following variables:

```env
  MYSQL_ROOT_PASSWORD=root_password
  MYSQL_DATABASE=drupal
  MYSQL_USER=drupal_database_user
  MYSQL_PASSWORD=drupal_database_password
```

## Getting Started

To get your Docker environment up and running, follow these steps:

### Building the Environment

To build and start your containers for the first time, run:

```bash
docker-compose up --build
```

This command builds the Drupal image as defined in your Dockerfile (if you're using a custom Dockerfile), and starts all the containers defined in docker-compose.yml.

```bash
# start env
docker-compose start

# stop env
docker-compose stop
```

## Install Drupal

Connect to drupal env

```bash
docker-compose exec drupal sh
```

and run (you can replace version if you want).

```bash
composer create-project --no-interaction "drupal/recommended-project:10.2.4" /opt/drupal
```
