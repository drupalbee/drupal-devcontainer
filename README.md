# Drupal devcontainer

This project provides a generic devcontainer setup designed for development of a Drupal website.

## Usage

1. Connect to remote VM with Docker installed over SSH. Use the following configuration in your SSH config file:

```bash
Host azure
  HostName <IP_ADDRESS>
  User <username>
  IdentityFile ~/.ssh/DrupalRemote_key.pem
  LocalForward 9003 localhost:9003
  LocalForward 8443 localhost:443
```

2. Clone this project to your remote computer.
3. Open the folder in Visual Studio Code, with [the Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) enabled.
4. When prompted to open in container, accept. If you miss the prompt, you can also open the command prompt and choose "Remote-Containers: Rebuild and Reopen in Container."

This will build the necessary containers and reopen VS Code within the Apache container ("web").

After building, the site can be browsed at https://localhost:8443, or https://drupal.dev:8443 if you set up your machine's hosts file with a record like:

```
127.0.0.1 drupal.dev
```

The admin account is:

```
Username: admin
Password: ZNB\*ufm1tyz4rwc@yzk
```

If you would like to change these before building the images, you can do so in `.devcontainer/scripts/postCreateCommand.sh`.

## Containers

The first container has PHP and Apache and is built on an official Drupal image. The second is a database container, using the official MariaDB image.
The setup includes:

- PHP 8.3 and PHP extensions recommended for Drupal 10: APCU and UploadProgress
- Latest version of composer.
- XDebug for PHP testing.
- User "www-data" with sudo permissions.
- Useful Drupal modules module_filter, admin_toolbar, and environment_indicator with configuration.
- Useful VS Code extensions and settings including Drupal formatting standards.
- SSH folder and .gitconfig as volumes, so if your SSH keys are in the standard user profile's .ssh folder and you clone with SSH, there won't be any extra steps necessary to connect to the repository with your configuration.
- A dark mode colour palette.
- Grep colour highlighting for easier reading of results.

## Data Storage

Website data is stored in the "web" container, and the database data is stored in the "db" container. The database data is stored in a bind volume, as well as Drupal data, so both will persist between container rebuilds.

## Folder structure

Here is the folder structure for website data:

```bash
.
├── README.md
├── composer.json
├── composer.lock
├── docker-compose.yml
├── patches
├── private
├── sync
│   └── config
└── web
    ├── INSTALL.txt
    ├── README.md
    ├── example.gitignore
    ├── index.php
    ├── modules
    ├── profiles
    ├── robots.txt
    ├── sites
    ├── themes
    ├── update.php
    └── web.config
```

`web` folder exist in the root of the project and contains the Drupal website files. The `private` and `sync` folders are used for Drupal configuration and private files, respectively.

In case you need to modify the code internally and then commit it, it is possible to do so by creating a new branch and pushing it to the repository like you always do in regular linux systems.

