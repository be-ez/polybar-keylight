# polybar-keylight
A script for toggling a single Elgato Keylight

## Requirements

 - Go
 - [keylight CLI command](https://github.com/mdlayher/keylight)
 - IPC enabled in Polybar `enable-ipc = true`
 - Default on/off requires Nerdfont

## Example Setup

Install Keylight CLI
```
go install github.com/mdlayher/keylight/cmd/keylight@latest
```

Copy script to Polybar
```
git@github.com:be-ez/polybar-keylight.git && cd polybar-keylight
mkdir -p $HOME/.config/polybar/scripts
cp keylight.sh $HOME/.config/polybar/scripts
```

Include Module
```sh
[module/keylight]
type = custom/ipc
hook-0 = $HOME/.config/polybar/scripts/keylight.sh -p
hook-1 = $HOME/.config/polybar/scripts/keylight.sh -p
click-left = $HOME/.config/polybar/scripts/keylight.sh -t
initial = 1
```
