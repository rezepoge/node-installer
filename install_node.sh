#!/bin/bash

# Colors
DUN='\033[1;35m'
BLU='\033[1;34m'
ORA='\033[0;33m'
GRE='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables
ALGO="gz"
VERSION_INFO=$(curl -s https://nodejs.org/dist/index.tab)
VERSION=$(echo "$VERSION_INFO" | grep Iron | grep -Po "v[0-9.]{3,}")
INSTALL_DIR="/usr/include/node"
BINARY_DIR="/usr/bin"
CREATE_SYMLINKS=0

echo -e "${DUN}MiddelSoft Node-Installer ${NC}
"

#Get Params
while getopts "hxlv:i:b:s" OPTION
do

    case $OPTION in
        h)
            echo -e "${GRE}-h${NC} prints this help
    
    ${GRE}-x${NC} changes download form .tar.gz to .tar.xz
       xz is smaler but takes longer to extract.
    
    ${GRE}-v${NC} *VERSION* lets you set the node version to install (ex. -v v20.9.0 or -v latest)
       default version is lts iron. Visit https://nodejs.org/dist/ for possible versions.
       atm only versions like 'v20.9.0' are possible, versions like 'latest' don't.

    ${GRE}-i${NC} *INSTALL_DIR* lets you set a custom path where to install node.
       default is /usr/include/node
       
    ${GRE}-b${NC} *BINARY_DIR* lets you set a custom path where to set the symlinks to the binaries.
       default is /usr/bin
       Only effective with option -s to create symlinks
       
    ${GRE}-s${NC} creates symlinks for the binary files
       default is /usr/bin/node
                  /usr/bin/npm
                  /usr/bin/npx

    ${GRE}-l${NC} installs the latest version.
"
            exit 1;
            ;;
        x)
            ALGO="xz"
            ;;
        v)
            VERSION=$OPTARG
            ;;
        i)
            INSTALL_DIR=$OPTARG
            ;;
        b)
            BINARY_DIR=$OPTARG
            ;;
        s)
            CREATE_SYMLINKS=1
            ;;
        l)
            VERSION=$(echo "$VERSION_INFO" | head -n 2 | grep -Po "v[0-9.]{3,}")
            ;;
    esac
done

# Set Arch
case $(uname -m) in
    armv6l)
        ARCH="linux-armv6l"
        ;;
    armv7l)
        ARCH="linux-armv7l"
        ;;
    aarch64)
        ARCH="linux-arm64"
        ;;
    x86_64)
        ARCH="linux-x64"
        ;;
esac

if [ -z "$ARCH" ]; then
    echo "Your systems architecture could not be determined.
Please contact tm@reze.li and include following infos:

---
$(uname -a)
$(uname -m)
---
"
    exit 77
fi
    
echo -e "going to download and install ${GRE}node-$VERSION${NC} for ${RED}$ARCH${NC}
to $INSTALL_DIR
"

echo -e "${ORA}Press any key to continue...${NC}"
read -s -n 1

NODE_NAME="node-$VERSION-$ARCH"
FILENAME="$NODE_NAME.tar.$ALGO"
DOWNLOAD_URL="https://nodejs.org/dist/$VERSION/$FILENAME"

cd /tmp
wget "$DOWNLOAD_URL"

echo "unzipping archive"
tar -xf "$FILENAME"

echo "removing archive"
rm "/tmp/$FILENAME"

if [ -d "$INSTALL_DIR" ]; then
    echo "cleaning install directory"
    rm -rf "$INSTALL_DIR"
else 
    echo "creating install directory"
    mkdir -p "$INSTALL_DIR"
fi

echo "moving files install directory"
mv "/tmp/$NODE_NAME" "$INSTALL_DIR"

if [ $CREATE_SYMLINKS -eq 1 ]; then
    echo "setting symlinks"
    ln -sf "$INSTALL_DIR/bin/node" "$BINARY_DIR/node"
fi

echo -e "${GRE}done.${NC}
"