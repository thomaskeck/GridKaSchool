GKUSER=gks
PASSWORD=thebestscipyintroductionatthegridkaschool

# Install required packages
apt-get update
apt-get install -y python3-pip python3-virtualenv
apt-get install -y libfreetype6-dev libpng12-dev pkg-config
apt-get install -y llvm libedit-dev
apt-get install -y git

time su - "gks" -c "bash /tmp/uscript.sh"
