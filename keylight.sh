#!/bin/bash

usage() {

cat << EOT

  usage $0 [-htbkp]
        $0 -t
        $0 -b 10
        $0 -k 2700k (unfinished)
        $0 -p

  OPTIONS
    -h Show keylight help
    -t Toggle keylight state
    -b Set brightness to x of 100
    -k Set color temp to t (unfinished)
    -p Get Polybar String
EOT
}

KEYLIGHT_CLI=${foo:-$GOPATH/bin/keylight}
KEYLIGHT_ON_STRING=" ﯦ"
KEYLIGHT_OFF_STRING=""
 
# Get Keylight state without changing
getStateCMD="${KEYLIGHT_CLI} -i"

# Toggle keylight
toggleStateCMD="${KEYLIGHT_CLI}"


parseStateString(){
    if [[ $stateString == *"off"* ]]; then
        state="off"
        brightness=0
    else
        state="on"
        brightness=$(echo "${stateString}" | jq -R 'split(",")[2]' | sed 's/[^0-9]*//g')
        colorTemp=$(echo "${stateString}" | jq -R 'split(",")[2]' | jq -R 'split(":")[1]' | sed 's/[^0-9]*//g')
    fi
}

getCurrentState() {
    stateString=$($getStateCMD 2>&1)
    parseStateString
}

toggleState() {
    getStateCMD=$($toggleStateCMD 2>&1)
    parseStateString
    if [[ $state == "on" ]]; then
        polybar-msg action "#keylight.hook.0"
    else
        polybar-msg action "#keylight.hook.1"
    fi
}

getPolybarString() {
    getCurrentState
    if [[ $state == "on" ]]; then
        echo "${KEYLIGHT_ON_STRING}"
    else
        echo "${KEYLIGHT_OFF_STRING}"
    fi
}

while getopts "htbkp" option; do
    case $option in
        # Toggle State
        t)
          toggleState
          exit 0
          ;;
        b)
          brightness="$OPTARG"
          echo "${brightness}"
          exit 0
          ;;
        k)
          colorTemp="$OPTARG"
          echo "${colorTemp}"
          exit 0
          ;;
        p)
          getPolybarString
          exit 0
          ;;
        \?)
          echo "wrong option."
          usage
          exit 1
          ;;
        h)
          usage
          exit 0
          ;;
    esac
done
shift $((OPTIND - 1))

if [ "$#" == 0 ]; then
  getPolybarString
  exit 0
fi
