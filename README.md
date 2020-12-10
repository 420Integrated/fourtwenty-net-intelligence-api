420coin Network Intelligence API
============
[![Build Status][travis-image]][travis-url] [![dependency status][dep-image]][dep-url]

This is the backend service which runs along with 420coin and tracks the network status, fetches information through JSON-RPC and connects through WebSockets to [fourtwenty-netstats](https://github.com/420integrated/fourtwenty-netstats) to feed information. For full install instructions please read the [wiki](https://420integrated.com/wiki).


## Prerequisite
* fourtwenty, or g420
* node
* npm


## Installation on an Ubuntu EC2 Instance

Fetch and run the build shell. This will install everything you need: latest 420coin - CLI from develop branch (you can choose between fourtwenty or g420), node.js, npm & pm2.

```bash
bash <(curl https://raw.githubusercontent.com/420integrated/fourtwenty-net-intelligence-api/master/bin/build.sh)
```
## Installation as docker container (optional)

There is a `Dockerfile` in the root directory of the repository. Please read through the header of said file for
instructions on how to build/run/setup. Configuration instructions below still apply.

## Configuration

Configure the app modifying [processes.json](/fourtwenty-net-intelligence-api/blob/master/processes.json). Note that you have to modify the backup processes.json file located in `./bin/processes.json` (to allow you to set your env vars without being rewritten when updating).

```json
"env":
	{
		"NODE_ENV"        : "production", // tell the client we're in production environment
		"RPC_HOST"        : "localhost",  // 420coin JSON-RPC host
		"RPC_PORT"        : "6174",       // 420coin JSON-RPC port
		"LISTENING_PORT"  : "13013",      // 420coin listening port (only used for display)
		"INSTANCE_NAME"   : "",           // whatever you wish to name your node
		"CONTACT_DETAILS" : "",           // add your contact details here if you wish (email/skype)
		"WS_SERVER"       : "wss://rpc.fourtwentystats.420integrated.com", // path to fourtwenty-netstats WebSockets api server
		"WS_SECRET"       : "see https://420integrated.com/wiki/fourtwentystats-add-node/", // WebSockets api server secret used for login
		"VERBOSITY"       : 2 // Set the verbosity (0 = silent, 1 = error, warn, 2 = error, warn, info, success, 3 = all logs)
	}
```

## Run

Run it using pm2:

```bash
cd ~/bin
pm2 start processes.json
```

## Updating

To update the API client use the following command:

```bash
~/bin/www/bin/update.sh
```

It will stop the current netstats client processes, automatically detect your 420coin implementation and version, update it to the latest develop build, update netstats client and reload the processes.