# Ubuntu 26.04 Development Environment Setup

**Stack:** Docker, Docker Compose, .NET 10, Node.js 26 LTS, npm, NVM, Git.

> Run this on a fresh Ubuntu 26.04 machine. It configures Git identity, installs .NET and NVM/Node.js, and configures Docker group access. Docker group membership grants root-equivalent privileges.

```bash
#!/usr/bin/env bash
set -e

# ==========================================
# 1. Verify OS and architecture
# ==========================================
cat /etc/os-release
uname -m

# ==========================================
# 2. Install .NET SDK 10 and curl
# ==========================================
sudo apt update
sudo apt install -y curl dotnet-sdk-10.0

dotnet --version
dotnet --list-sdks
dotnet --list-runtimes

# ==========================================
# 3. Install NVM
# ==========================================
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash

# Load NVM in this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

command -v nvm
nvm --version

# ==========================================
# 4. Install Node.js 26 LTS
# ==========================================
nvm install 26
nvm use 26
nvm alias default 26

node --version
npm --version
nvm current
npm config get prefix

# ==========================================
# 5. Verify Docker and Compose
# ==========================================
git --version
docker --version
docker compose version

# ==========================================
# 6. Configure Docker permissions
# ==========================================
sudo usermod -aG docker "$USER"

# Apply Docker group membership to this shell
newgrp docker <<'DOCKER_TEST'
docker info --format 'Docker Server: {{.ServerVersion}}'
docker run --rm hello-world
DOCKER_TEST

# ==========================================
# 7. Configure Git
# ==========================================
git config --global user.name "Soheil"
git config --global user.email "soheil.amiri@live.com"
git config --global init.defaultBranch main

git config --global --list
git --version

# ==========================================
# 8. Final environment verification
# ==========================================
printf '\n--- OS ---\n'
lsb_release -ds

printf '\n--- Git ---\n'
git --version

printf '\n--- Docker ---\n'
docker --version
docker compose version
docker info --format 'Server: {{.ServerVersion}}'

printf '\n--- .NET ---\n'
dotnet --version

printf '\n--- Node.js ---\n'
node --version
npm --version
nvm current

printf '\n--- Git default branch ---\n'
git config --global --get init.defaultBranch

echo "Ubuntu development environment preparation completed."
```