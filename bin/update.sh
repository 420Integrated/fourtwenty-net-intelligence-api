#!/bin/bash

# setup colors
red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
bold=`tput bold`
reset=`tput sgr0`

heading()
{
	echo
	echo "${cyan}==>${reset}${bold} $1${reset}"
}

success()
{
	echo
	echo "${green}==>${bold} $1${reset}"
}

error()
{
	echo
	echo "${red}==>${bold} Error: $1${reset}"
}

heading "Updating 420coin"

# figure out what we have to update
if [[ -f /usr/bin/g420 ]];
then
	fourtwentytype="g420"
	success "Found g420"
else
	if [[ -f /usr/bin/fourtwenty ]];
	then
		fourtwentytype="fourtwenty"
		success "Found fourtwenty"
	else
		error "Couldn't find 420coin"
		exit 0
	fi
fi

heading "Stopping processes"
pm2 stop all

heading "Flushing logs"
pm2 flush
rm -Rf ~/logs/*
rm -rf ~/.local/share/Trash/*

heading "Stopping pm2"
pm2 kill

heading "Killing remaining node processes"
echo `ps auxww | grep node | awk '{print $2}'`
kill -9 `ps auxww | grep node | awk '{print $2}'`

heading "Removing 420coin"
sudo apt-get remove -y $fourtwentytype

heading "Updating repos"
sudo apt-get clean
sudo add-apt-repository -y ppa:420integrated/go-420coin
sudo add-apt-repository -y ppa:420integrated/go-420coin-dev
sudo apt-get update -y
sudo apt-get upgrade -y

heading "Installing 420coin"
sudo apt-get install -y $fourtwentytype

heading "Updating fourtwenty-netstats client"
cd ~/bin/www
git pull
sudo npm update
cd ..

success "420coin was updated successfully"

heading "Restarting processes"
pm2 start processes.json
