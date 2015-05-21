#!/bin/bash
function checkIfCommandExist {
    # Return 0 if a command does not exist
    command -v $1 >/dev/null 2>&1 || {
        echo 0
        return
    }
    echo 1
}

function installPackage {
    # Install package with package name is argument 1
    case "$osname" in
        ubuntu)
            apt-get -q -y install  $1
            ;;
        debian)
            apt-get -q -y install $1
            ;;
        linuxmint)
            apt-get -q -y install $1
            ;;
        centos)
            yum -y install $1
            ;;
        fedora)
            yum -y install $1
            ;;
    esac
}

# install curl if it does not exist
if [ $(checkIfCommandExist curl) -eq 0 ]; then
   install curl
fi

# Make sure user runs this bash script as root
if [ $(id -u) -ne 0 ]; then
    echo "You need to run as root user"
    exit
fi

echo "Download and install iojs"

# Get version of iojs from argument
if [ -z "$1" ]; then
    echo 'Get iojs version from https://iojs.org'
    iojsversion=`curl -sL https://iojs.org/en/index.html | sed -nre 's/.*\/v([0-9]*\.[0-9]*\.[0-9]*)\/.*/\1/p' | head -1`
else
    iojsversion=$1
fi

# Check if node is installed
if [ $(checkIfCommandExist node) -eq 1 ]; then
    nodeversion=$(node -v)

    # Remove v and . from  node version string
    nodeversionnumber=${nodeversion//[v.]/}
    iojsversionnumber=${iojsversion//./}

    if [ $nodeversionnumber -lt $iojsversionnumber ]; then
        echo "Installed node version is older. Upgrade now"
    else
        echo "Installed node version: $nodeversion is up to date"
        exit
    fi
fi

iojsfile="iojs-v${iojsversion}-linux-x64.tar.gz"

# Check if iojs-vx.y.z-linux-x64.tar.gz exists in current path
if [ -f "$iojsfile" ]; then
    echo "$iojsfile found."
else
    echo "$iojsfile not found."
    remote_file=https://iojs.org/dist/v${iojsversion}/${iojsfile}

    # Use curl to check if remote file is downloadable
    file_exist=$(curl  -s -o /dev/null -IL -w %{http_code} $remote_file)
    if [ $file_exist -eq 200 ]; then
        echo "Start download: $remote_file"
        curl -O $remote_file #download and save file to current folder
    else
        echo -e  "\e[41m$remote_file does not exist\e[49m"
        exit
    fi
fi

echo "Extract ${iojsfile}"
tar -xzf ${iojsfile}

if [ -d "iojs-v${iojsversion}-linux-x64" ]; then
    echo "Extract to folder iojs-v${iojsversion}-linux-x64 successfully"
else
    echo "Extract failed"
    exit
fi

echo "Move iojs-v${iojsversion} to /opt folder"

# If in /opt folder there is already iojs folder, then remove it
if [ -d "/opt/iojs-v${iojsversion}" ]; then
    rm -rf /opt/iojs-v${iojsversion}
fi

mv iojs-v${iojsversion}-linux-x64 /opt/iojs-v${iojsversion}

echo "Create symbolic links to iojs, node, npm"
rm -f /usr/bin/iojs
rm -f /usr/bin/node
rm -f /usr/bin/npm

ln -s /opt/iojs-v${iojsversion}/bin/iojs /usr/bin/iojs
ln -s /opt/iojs-v${iojsversion}/bin/node /usr/bin/node
ln -s /opt/iojs-v${iojsversion}/bin/npm /usr/bin/npm

# Results
echo "node version: `node -v`"
echo "iojs version: `iojs -v`"
echo "npm version: `npm -v`"

source shell_scripts/node_path.sh -a

# Grant execution permission for shell_scripts directory
chmod -R u+x shell_scripts

# Open port for Web installer
os=`./shell_scripts/os/get_os_id.sh`
os_name=`echo $os | awk -F"-" '{print $1}'`
os_version=`echo $os | awk -F"-" '{print $2}'`
./shell_scripts/os/open_port.sh $os_name $os_version 3000

# Run Web installer
sudo npm install
node bin/www
