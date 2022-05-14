#!/bin/bash
# Chaindeps installer 
# installs everything we need for programming on the blockchain. 
# assumes an Arch Linux or Ubuntu environment.
set -euf -o pipefail
# vars
welcomeScreen="Welcome to Chaindeps Installer!"
welcomeScreen2="We're going to install everything we need to get your system ready for web3 dev."
updating_sys="Updating your system. Please be patient."
sys_updated="System updated. Continuing..."
UPDATE_ARCH=$(sudo pacman --noconfirm -Syu)
UPDATE_UBUNTU=$(sudo apt-get update -y && sudo apt-get upgrade -y)
DETECT_ARCH=$(which pacman) # detects pacman on the system = arch-base
DETECT_UBUNTU=$(which apt)  # detects apt on the system = ubuntu-base
is_yay_installed=$(which yay) # detects yay for aur
clone_yay=$(git clone https://aur.archlinux.org/yay.git) # builds and installs yay
arch="Arch Linux"
ubuntu="Ubuntu Linux"
os_detect="Detecting your current operating system before proceeding..."
ARCH_NEEDED_PKGS="git npm nodejs go-ipfs"	# needed Arch packages.
UBUNTU_NEEDED_PKGS="git npm nodejs go-ipfs ipfs-desktop" 	# needed Ubuntu packages.
npm_truffle=$(npm install -g truffle) # install truffle from npm
npm_solc=$(npm install -g solc)	      # install solc (solidity compiler) from npm
r3_vim_sol_repo="https://github.com/rav3ndust/vim-solidity"
vim_sol_localfiles="~/.vim/pack/default/start"
SLEEPY=$(sleep 1)
ERR="Sorry, you are not on a currently supported operating system. Exiting."
notif_SUCCESS=$(notify-send "Chaindeps Installer" "Web3 toolchains installed. Start building!")
notif_FAIL=$(notify-send "Chaindeps Installer" "Web3 toolchains installation failed. Please see error logs.")
npm_web3JS=$(npm install web3)
PM_Help_Location="https://github.com/ProcessMedic/ProcessToken"
ERR_TERM="Something went wrong. Terminating process."
#########################################################
# - - - F u n c t i o n s - - - 			#
#########################################################
# Separate distro-specific funcs for simplicity.	#
#########################################################
# arch-specific funcs					#
#########################################################
arch_distro_update () {
	# updates arch before continuing.
	echo $updating_sys
	$SLEEPY
	$UPDATE_ARCH || echo $ERR_TERM
	echo $sys_updated
	$SLEEPY
}
arch_install_pkgs () {
	# install the packages we need from pacman. 
	# if needed, we can build others from the AUR. 
	pkgInstall="Installing the needed development packages for your web3 toolchain."
	pkgsInstalled="Your packages have installed." 
	echo $pkgInstall
	$SLEEPY
	sudo pacman -S --noconfirm $ARCH_NEEDED_PKGS || echo $ERR_TERM 
	$SLEEPY && echo $pkgsInstalled
	$SLEEPY && echo "Moving on..."
}
build_yay_helper () {
	# handles the process of downloading, building, and installing yay for AUR
	building_yay="Yay AUR helper not detected on this system."
	building_yay_2="Building and installing it for you."
	yay_installed="Yay AUR Helper installed. Building needed packages from the AUR..."
	echo $building_yay
	$SLEEPY
	echo $building_yay_2
	cd $HOME
	mkdir pkgs && cd pkgs	
	$SLEEPY	
	$clone_yay
	cd yay && makepkg -si
	echo $yay_installed
	$SLEEPY
}
isYay_Installed () {
	# looks for yay on the system, runs "build_yay_helper" if not 
	look4yay="Detecting Yay AUR Helper on this machine, installing it if not..."
	yay_is_here="Yay is already installed. Moving on..."
	yay_isNot_here="Yay not detected. Installing it for you..."
	yaypkg="Yay AUR Helper"
	whatis_AUR="Now, you can install even more software from the Arch User Repository!"
	echo $look4yay && $SLEEPY
	if [[ $is_yay_installed ]]; then
		echo $yay_is_here
		$SLEEPY
		echo "Moving on..."
	else
		echo $yay_isNot_here
		$SLEEPY
		build_yay_helper
		echo "The $yaypkg has been built."
		$SLEEPY
		echo $whatis_AUR
	fi 
}
vim_sol_apply_ARCH () {
	# applies our vim configs for solidity. 
	vimConfigs="Applying Vim configuration for Solidity language support..."
	finished_apply="Vim Solidity config copied. Please check for it in $vim_sol_localfiles."
	edits="You can make any edits you would like to the configuration in that file."
	cd $HOME
	echo $vimConfigs
	sudo pacman --noconfirm -S vim # install vim if not already present
	sudo mkdir -p $vim_sol_localfiles
	cd $vim_sol_localfiles && git clone $r3_vim_sol_repo
	echo $finished_apply && $SLEEPY
}
build_ipfs_desktop_ARCH () {
	# fetches and builds the IPFS desktop application using yay from the AUR.
	prep="Preparing to build ipfs-desktop..."
	fetch="Fetching needed files from the AUR..."
	BUILD_IPFS_DESKTOP=$(yay -S ipfs-desktop)
	ipfsD_built="IPFS Desktop has been built."
	echo $prep
	$SLEEPY
	echo $fetch
	$BUILD_IPFS_DESKTOP || echo $ERR_TERM
	$SLEEPY
	echo $ipfsD_built
}
#########################################################
# ubuntu-specific functions
#########################################################
ubuntu_distro_update () {
	# updates ubuntu before continuing.
	echo $updating_sys
	$SLEEPY
	$UPDATE_UBUNTU || echo $ERR_TERM
	echo $sys_updated
	$SLEEPY && echo "Continuing..."
}
ubuntu_install_pkgs () {
	# install the needed ubuntu packages in this func.
	ub_pkgs_install="Installing the needed Ubuntu packages for your web3 development toolchain."
	ub_pkgs_installed="Your packages have been installed."
	echo $ub_pkgs_install
	$SLEEPY
	sudo apt-get -y install $UBUNTU_NEEDED_PKGS || echo $ERR_TERM
	$SLEEPY && echo $ub_pkgs_installed
	$SLEEPY && echo "Moving on..."
}
#########################################################
# handle some npm stuff for needed js/solidity tools.
#########################################################
do_npm_stuff () {
	# grabs npm and needed tools.
	# these include truffle, web3, and solc.
	npm_install="Installing npm and needed Javascript tools..."
	npm_installed="npm and needed packages installed. Moving on..."
	truffle_In="Installing Truffle from npm..."
	err1="npm installation of truffle failed. See logs."
	web3_In="Installing web3 from npm..."
	err2="npm installation of web3 failed. See logs."
	solc_In="Installing solc Solidity compiler from npm..."
	err3="npm installation of solc failed. See logs."
	echo $npm_install || echo $ERR_TERM
	$SLEEPY
	echo $truffle_In
	$npm_truffle || echo $err1	# install truffle
	$npm_web3JS || echo $err2	# install web3.js
	$npm_solc || echo $err3 	# install solc Solidity compiler
	$SLEEPY
	echo $npm_installed && $SLEEPY
	echo "Moving on..."
}
# begin script
echo $welcomeScreen
sleepy
echo $welcomeScreen2
sleepy
echo $os_detect
# detect operating system. 
# we currently only support Arch and Ubuntu-based distros. Other OS detections should cause err.
if [[ $DETECT_ARCH ]]; then
	ON_ARCH=1
	proceed_arch="Proceeding with Arch-specific functions."
	arch_exit="All packages for your Arch system have been installed."
	echo "$arch system detected."
	$SLEEPY
	echo $proceed_arch
	# Update Arch with the latest repos.
	arch_distro_update
	# install the needed pkgs. 
	arch_install_pkgs
	# check for yay on the sys, build it if not present.
	isYay_installed
	# clone the Solidity Vim file to vim. Then, ensure we have ipfs-desktop. 
	vim_sol_apply_ARCH
	$SLEEPY
	build_ipfs_desktop_ARCH
	$SLEEPY
	# install everything we need from npm.
	do_npm_stuff && $SLEEPY
	echo $arch_exit && $SLEEPY
elif [[ $DETECT_UBUNTU ]]; then
	ON_UBUNTU=1
	proceed_ubuntu="Proceeding with Ubuntu-specific installation."
	ubuntu_exit="All packages for your Ubuntu system have been installed."
	echo "$ubuntu system detected."
	$SLEEPY
	echo $proceed_ubuntu
	# update Ubuntu with the latest repos.
	ubuntu_distro_update
	$SLEEPY
	# install the needed packages.
	ubuntu_install_pkgs
	$SLEEPY
	# install everything we need from npm.
	do_npm_stuff && $SLEEPY
	echo $ubuntu_exit && $SLEEPY
else
	echo $ERR & $notif_FAIL	
	exit 
fi
echo "Everything has been installed and configured for your web3 toolchain."
$SLEEPY && $notif_SUCCESS
echo "Feel free to explore the new packages, or check out $PM_Help_Location for further reading."
$SLEEPY
echo "Now you're all set to build on the new, decentralized internet."  # i think that's the right way to say it
$SLEEPY && exit
