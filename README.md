# Docker Compose for Drupal and MySQL with Nginx

This project sets up a Docker environment for a Drupal site, using MySQL as the database and Nginx as the web server.

## Prerequisites

- Docker
- Docker Compose

## Directory Structure

- `./db-data`: Stores MySQL data for persistence.
- `./drupal`: Where the Drupal source code is stored and edited.
- `./nginx-conf`: Contains Nginx configuration files.
- `./docker`: Contains the Dockerfile used to build the Drupal image.

## Installation

1. Clone the repository to your local environment.
2. Create a `.env` file in the root of the project with the necessary environment variables.
3. Run `docker-compose up -d` to start all services in detached mode.

.env sample
```bash
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=drupal
MYSQL_USER=drupal_database_user
MYSQL_PASSWORD=drupal_database_password
```

## Accessing Containers

To access any container, use the `docker exec` command. For example, to access the MySQL container:

```bash
# change the user for the user set in .env
docker exec -it mysql mysql -u drupal_database_user -p
```

For the Drupal container:

```bash
docker-compose exec drupal /bin/bash
```

## Starting and Stopping Containers

To stop a container, use:

```bash
docker-compose stop
```


To start a container, use:
```bash
docker-compose start
```

## Important Notes

- **Do not directly modify the `./db-data` directory.** It is used to ensure data persistence for the MySQL database across container restarts.
- Ensure that the volumes and networks are correctly configured in your `docker-compose.yml` to avoid connectivity issues or data loss.


# Zsh Configuration for Drush and Composer with Docker

This guide will help you configure your Zsh environment to automatically use `drush` and `composer` with Docker in specific project directories.

## Prerequisites

- Zsh installed and set as your shell.
- Docker installed and configured.
- Docker containers that contain the `drush` and `composer` tools.

## Configuration

Follow these steps to set up your Zsh environment to use `drush` and `composer` inside a Docker container when in a specific project directory.

1. Open your Zsh configuration file (usually `~/.zshrc`) in a text editor.

2. Add the following script at the end of the file:

```shell
   autoload -U add-zsh-hook

   setupDrushComposer() {
       local projectDirs=(
           "path/to/your/project"
           # Add more directory paths here as needed
       )

       local currentDir="$(pwd)"

       for dir in "${projectDirs[@]}"; do
           if [[ "$currentDir" == "$dir" ]]; then
               alias drush='docker exec -it drupal drush'
               alias composer='docker exec -it drupal composer'
               return  # Exit the function after setting the aliases
           fi
       done

       # Clear the aliases if not in a project directory
       unalias drush 2> /dev/null
       unalias composer 2> /dev/null
   }

   add-zsh-hook chpwd setupDrushComposer
```

3. Save and close the file.

4. Reload the configuration file with the command:

```shell
source ~/.zshrc
```

## Usage

With this setup, whenever you change to one of the specified directories in projectDirs, the drush and composer commands will automatically be available for execution inside your Docker container. Outside these directories, the aliases will be removed to prevent conflicts or accidental execution.

## Customization

Modify projectDirs to include the directories of your projects where you want these aliases enabled.
Replace drupal in the command docker exec -it drupal with the name of your Docker container where the tools are installed.

Once configured, you will be able to run drush and composer directly in your terminal, and the commands will be executed inside the specified Docker container.