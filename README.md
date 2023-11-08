# node-installer
a simple bash script for linux to install node-js

# usage
## install script to /opt and make it executeable via inode
```cd /opt && wget https://www.middelsoft.de/scripts/install_node.sh && chmod +x /opt/install_node.sh && ln -s /opt/install_node.sh /usr/bin/inode```

## options

-h prints help

-x changes download form .tar.gz to .tar.xz
       xz is smaler but takes longer to extract.

-v *VERSION* lets you set the node version to install (ex. -v v20.9.0 or -v latest)
   default version is lts iron. Visit https://nodejs.org/dist/ for possible versions.
   atm only versions like 'v20.9.0' are possible, versions like 'latest' don't.

-i *INSTALL_DIR* lets you set a custom path where to install node.
   default is /usr/include/node

-b *BINARY_DIR* lets you set a custom path where to set the symlinks to the binaries.
   default is /usr/bin
   Only effective with option -s to create symlinks

-s creates symlinks for the binary files
   default is /usr/bin/node
              /usr/bin/npm
              /usr/bin/npx

-l installs the latest version.
