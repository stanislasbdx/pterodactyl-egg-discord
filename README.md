# 🤖 — Discord.JS Pterodactyl Bot Hosting Egg and Docker image

This is an egg dedicated to NodeJS bot hosting (discord.js & nodejs) on pterodactyl panel.

> Docker image: <https://hub.docker.com/r/5140/discord-egg>
>
> Github Repository <https://github.com/stanislasbdx/pterodactyl-egg-discord⁠>

An issue ? A suggestion ? Open an issue on Github or DM me on discord (stan1712) !

> [!IMPORTANT]  
> **If you run on ARM system, go check [Mizari's project](https://github.com/Mizari-Dev/pterodactyl-egg-nodejs-arm64)**, or you won't be able to use this and be sad 😓 ([here's what you can expect](https://github.com/stanislasbdx/pterodactyl-egg-discord/issues/5)).

## 🏗️・Installation

To install this egg :

1. Go into Admin panel
2. Go to "Nests"
3. Click "Import Egg"
4. Choose the .json file named "egg-discordjs"
5. And import !

## 🌌・Usage

To use it, just create a server with this egg in the "Nest Configuration" section.

### Creating a server

#### Docker image

By default when creating a server, the docker image will be the latest (stable), but you can choose the others proposed in the list or use your custom one *(you won't get support tho)*.

![image](https://github.com/user-attachments/assets/153a0391-91b2-436f-bc7e-66b7ac070727)

##### Tags

- `latest` : Stable tag with active LTS Node Version
- `snapshot` : Development tag with a bit of chaos sometimes (may not work too)
- `node-xx` : Tag for each supported NodeJS version

> [!WARNING]  
> Usage of EOL Node versions will not be accepted if you have an issue.

#### Defaults files from repository

In addition you can choose from where to get the default project files like **index.js** and **package.json**.
> Default value : <https://raw.githubusercontent.com/stanislasbdx/pterodactyl-egg-discord/refs/heads/master/>

![image](https://github.com/user-attachments/assets/05efea31-dbb9-4d94-82da-12a6dc8b5366)

## 🤝・Contributing

### Building a Docker image

You can build the docker image with the LTS Node version, or a specific version.

```bash
podman build .

# To build in specific Node version
podman build --build-arg NODE_VERSION=18 .
```
