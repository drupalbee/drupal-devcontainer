# Drupal devcontainer

This project provides a generic devcontainer setup designed for development of a Drupal website.

## Usage

1. Connect to remote VM over SSH. Use the following configuration in your SSH config file on your local machine. REMEMBER - these actions are should be done on your local machine, not on the remote VM!

```bash
# create the config file if it doesn't exist
touch ~/.ssh/config

# open the config file
nano ~/.ssh/config
```
add the following configuration to the file:

```bash
Host azure
  HostName <IP_ADDRESS>
  User <username>
  IdentityFile <path_to_your_pem_file>
  LocalForward 9003 localhost:9003
  LocalForward 8443 localhost:443
```
2. Test the connection by running the following command:

```bash
ssh azure
```
After this step you should be successfully connected to the remote VM. If you are not, please check the configuration and try again.

3. Clone the repository ON THE REMOTE VM:

```bash
cd $HOME
git clone https://github.com/eugenezimin/drupal-devcontainer.git
```

Install Docker and other dependencies on the REMOTE VM:

```bash
# Install Docker prerequisites
sudo apt update
sudo apt install ca-certificates curl
# Set up Docker repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker packages
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin default-jre
# Configure Docker permissions
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
````

Now you may disconnect from the remote VM and continue working on your local machine.

4. ON YOUR LOCAL MACHINE, open the Visual Studio Code and connect to the remote VM using the SSH configuration you created earlier. Click `Ctrl+Shift+P` and type `Remote-SSH: Connect to Host...` and select the `azure` host.
5. Whent you are connected to the remote VM, open a project folder where you cloned the project.
6. If you already installed [the Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) you need to wait a second for popup window and then click on `Reopen in Container. This will build the necessary containers and reopen VS Code within the Apache container ("web").

After all these steps, the site can be browsed at https://localhost:8443, or https://drupal.dev:8443 if you set up your machine's hosts file with a record like:

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

## Development

Since you were cloning a template repository, I bet you don't want to commit your changes to this repository, so you need to delete git data from the parent folder:

```bash
cd $HOME/drupal-devcontainer
rm -rf .git
```

and then reinitialize the repository:

```bash
git init
```

In case you need to modify the code internally and then commit it, it is possible to do so by creating a new branch and pushing it to the repository like you always do in regular linux systems.

