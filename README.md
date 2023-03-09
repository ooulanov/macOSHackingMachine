# macOSHackingMachine
Setting up a hacking macOS machine. Monitor mode, ettercap, macchanger, aircrack-ng, hashcat

## Requirements
1. Your MacBook must be older than 2018.
2. Disabled SIP
3. Everything was tested on macOS Monterey

## Basic steps
### Installing homebrew
Homebrew helps a lot with installation additional tools. To install just run\
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
### Enabling monitor mode
Monitoring mode is necessary if you want to engage in pentest Wi-Fi networks, sniff traffic and perform other attacks. So to enable it you need to open terminal and run command below. My Wi-Fi interface is en0, so after execution this command, new intarface (in my case en1) will appear.\
`
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
`\
![1](https://user-images.githubusercontent.com/127116376/223937088-980292ea-bf55-4c12-8452-994e51f23c05.png)
Now we can sniff traffic using en1 by running `sudo airport en1 -s` command.
![2](https://user-images.githubusercontent.com/127116376/223939358-fd81447d-1213-45b0-8e81-748cc87b8fd1.png)
### Installing CLI-tools
CLI-tools required to build many other tools. If you already have XCode installed, skip this step, if not, then you need to install the utility by executing\
`xcode-select --install`.
## Installing tools
### Installing macchanger
Macchanger helps you to stay anonymous, so to install it run:\
`sudo sh -c "curl -JL https://raw.githubusercontent.com/ooulanov/macOSHackingMachine/main/macchanger/macchanger.sh > /usr/local/bin/macchanger && chmod +x /usr/local/bin/macchanger"`
![3](https://user-images.githubusercontent.com/127116376/223948495-2e050a21-d552-41ea-a833-83f3f24015de.png)\
WARNING! This will not work with en1 (created earlier), because airport driver doesn't support changing MAC!
### Installing Metasploit
I have took an instruction from the official site:\
`curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall`\
Then we have to run msfconsole and proceed changes (answer yes after running this):\
`/opt/metasploit-framework/bin/msfconsole`\
After that we will have installed Metasploit!\
![image](https://user-images.githubusercontent.com/127116376/223950538-f2a37d51-3393-40eb-88d1-0825c2eab03b.png)
### Installing Nmap
Download installer from here (official website): https://nmap.org/download.html#macosx
Run installer and follow the instructions or use homebrew to install nmap:\
`brew install nmap`\
![image](https://user-images.githubusercontent.com/127116376/223960989-87cf1167-a3dd-441d-867e-0cfe9372eb0e.png)\
WARNING: nmap 7.93 on macOS shows openssl error, you should specify nmap version to 7.92 during installation or ignore error.
