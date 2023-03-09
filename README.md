# macOSHackingMachine
Setting up a hacking macOS machine. Monitor mode, ettercap, macchanger, aircrack-ng, hashcat

## Requirements
1. Your MacBook must be older than 2018.
2. Disabled SIP
3. Everything was tested on macOS Monterey

## Basic steps
### Enabling monitor mode
Monitoring mode is necessary if you want to engage in pentest Wi-Fi networks, sniff traffic and perform other attacks. So to enable it you need to open terminal and run command below. My Wi-Fi interface is en0, so after execution this command, new intarface (in my case en1) will appear.\
`
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
`\
![1](https://user-images.githubusercontent.com/127116376/223937088-980292ea-bf55-4c12-8452-994e51f23c05.png)
Now we can sniff traffic using en1 by running `sudo airport en1 -s` command.
![2](https://user-images.githubusercontent.com/127116376/223939358-fd81447d-1213-45b0-8e81-748cc87b8fd1.png)
### Installing CLI-tools
CLI-tools required to build many other tools. If you already have XCode installed, skip this step, if not, then you need to install the utility by executing `xcode-select --install`.
## Installing tools
### Installing macchanger
Macchanger helps you to stay anonymous, so to install it run ``
