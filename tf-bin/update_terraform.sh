#!/usr/bin/env bash
# get latest version of terraform
LATEST_VERSION=$(curl -LSs "https://releases.hashicorp.com/terraform/" 2> /dev/null \
  | grep -m1 -o "terraform_[0-9.]*" \
  | cut -d_ -f2)

echo "Updating terraform binaries to the latest version: $LATEST_VERSION"

# MacOS
echo "Updating binary file for MacOS"
url="https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_darwin_amd64.zip"
curl -s ${url} > ./terraform.zip
unzip -o -d ./darwin ./terraform.zip
rm ./terraform.zip

# Linux
echo "Updating binary file for Linux"
url="https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_linux_amd64.zip"
curl -s ${url} > ./terraform.zip
unzip -o -d ./linux-x64 ./terraform.zip
rm ./terraform.zip

# Windows
echo "Updating .exe file for Windows"
url="https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_windows_amd64.zip"
curl -s ${url} > ./terraform.zip
unzip -o -d ./winx64 ./terraform.zip
rm ./terraform.zip

