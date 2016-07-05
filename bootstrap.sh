#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

echo "Updating..."
apt-get -qq update

echo "Setting timezone."
echo 'US/Pacific' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# generally useful shit
echo "Installing dependencies..."
apt-get -qqy install build-essential libssl-dev
apt-get -qqy install freetds-dev # for sqlalchemy
apt-get -qqy install pkg-config libfreetype6-dev libpng12-dev # matplotlib
apt-get -qqy install libffi6 libffi-dev # for cryptography
apt-get -qqy install libsasl2-dev libldap2-dev # ldap
apt-get -qqy install libkrb5-dev krb5-user krb5-config #libkadm55 # kerberos
apt-get -qqy install libzmq3-dev

# python2
echo "Installing python2..."
apt-get -qqy install python-dev python-pip
pip install -q pyopenssl ndg-httpsclient pyasn1
#pip install -q virtualenvwrapper
pip install -q --upgrade pip

#echo "Setting up virtualenvs."
#source /usr/local/bin/virtualenvwrapper.sh
#export WORKON_HOME=/opt/envs/
#mkvirtualenv python2

pip install -qr /vagrant/requirements2.txt
ipython kernel install

# python 3 time!
echo "Installing python3..."
apt-get -qqy install python3-dev python3-pip
apt-get -qqy install python3-lxml
#mkvirtualenv python3 -p `which python3`
pip3 install -q pyopenssl ndg-httpsclient pyasn1
pip3 install -q --upgrade pip
pip3 install -qr /vagrant/requirements3.txt
ipython3 kernel install
deactivate

# ruby2
echo "Installing ruby2..."
apt-get -qqy install python-software-properties
apt-add-repository ppa:brightbox/ruby-ng
apt-get -qq update
apt-get -qqy install ruby2.1 ruby-switch
ruby-switch --set ruby2.1
apt-get -qqy install ruby2.1-dev
apt-get -qqy install zlib1g-dev
gem install -q pry awesome_print gnuplot rubyvis nyaplot
gem install -q rbzmq
gem install -q iruby

if [ -d "/vagrant" ]; then
    echo "Setting home user to: vagrant"
    HOME_USER=vagrant
else
    echo "Setting home user to: `SUDO_USER`"
    HOME_USER=`SUDO_USER`
fi

echo "Setting bash profile..."
echo "# display last command and log it to bootstrap file
alias strap=\"history | tail -n2 | sed -n '1p'  | sed 's/^[0-9 ]*//' | sed 's/sudo //' >> /vagrant/bootstrap.sh\"

# pip install and update requirements.txt
pipit() { sudo pip3 install \"$1\" && pip3 freeze | grep -v ubuntu > /vagrant/requirements3.txt; }
" >> /home/$HOME_USER/.bash_profile

chown -R $HOME_USER:$HOME_USER /opt /home/$HOME_USER/.bash_profile

#apt-get install -y git-core
#cd /opt && git clone http://www.github.com/gibiansky/IHaskell
#apt-get install -y haskell-platform
#/opt/IHaskell/ubuntu-install.sh
#cabal install ihaskell

echo "Done!"
