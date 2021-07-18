#!/bin/bash

cd /doge-chia

. ./activate

if [[ $(dogechia keys show | wc -l) -lt 5 ]]; then
    if [[ ${keys} == "generate" ]]; then
      echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
      dogechia init && dogechia keys generate
    elif [[ ${keys} == "copy" ]]; then
      if [[ -z ${ca} ]]; then
        echo "A path to a copy of the farmer peer's ssl/ca required."
        exit
      else
      dogechia init -c ${ca}
      fi
    elif [[ ${keys} == "type" ]]; then
      dogechia init
      echo "Call from docker shell: dogechia keys add"
      echo "Restart the container after mnemonic input"
    else
      dogechia init && dogechia keys add -f ${keys}
    fi
else
    for p in ${plots_dir//:/ }; do
        mkdir -p ${p}
        if [[ ! "$(ls -A $p)" ]]; then
            echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
        fi
        dogechia plots add -d ${p}
    done

    sed -i 's/localhost/127.0.0.1/g' ~/.dogechia/mainnet/config/config.yaml

    if [[ ${farmer} == 'true' ]]; then
      dogechia start farmer-only
    elif [[ ${harvester} == 'true' ]]; then
      if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
        echo "A farmer peer address, port, and ca path are required."
        exit
      else
        dogechia configure --set-farmer-peer ${farmer_address}:${farmer_port}
        dogechia start harvester
      fi
    else
      dogechia start farmer
    fi
fi

while true; do sleep 30; done;
