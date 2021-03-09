# AutoMuteUs on GCP

A script to setup AutoMuteUs bot on a free-tier VM in GCP.

## How to Use

- Register your bot in Discord [Developer Portal](https://discord.com/developers/applications) and create 1 or 2 (recommended) tokens following [README.md](https://github.com/denverquane/automuteus/blob/master/BOT_README.md)  in AutoMuteUs repo
- Click the button below to clone the repository into your CloudShell

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fnosu%2Fautomuteus-gcp&cloudshell_git_branch=main)

- Run the setup script as follows
```bash
export DISCORD_BOT_TOKEN=<token 1>
export DISCORD_WORKER_TOKEN=<token 2> #Optional
~/cloudshell_open/automuteus-gcp/deploy.sh
```
