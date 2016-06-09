#!/usr/bin/env bash
apt-get update
echo 'US/Pacific' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# generally useful shit
apt-get install -yq freetds-dev # for sqlalchemy
apt-get install -yq build-essential libssl-dev
apt-get install -yq libffi6 libffi-dev # for cryptography
apt-get install -yq libsasl2-dev libldap2-dev # ldap
apt-get install -yq libkrb5-dev krb5-user krb5-config libkadm55 # kerberos
apt-get install -yq libzmq3-dev

# python2
apt-get install -yq python-dev python-pip
pip install --upgrade pip
pip install -r /vagrant/requirements2.txt
ipython2 kernel install

# python 3 time!
apt-get install -y python3-dev python3-pip
apt-get install -y python3-lxml
pip3 install --upgrade pip
pip3 install -r /vagrant/requirements3.txt
ipython3 kernel install

# ruby2
apt-get install python-software-properties
apt-add-repository ppa:brightbox/ruby-ng
apt-get update
apt-get install -y ruby2.1 ruby-switch
ruby-switch --set ruby2.1
apt-get install -y ruby2.1-dev
apt-get install -y zlib1g-dev
gem install pry awesome_print gnuplot rubyvis nyaplot
gem install rbzmq
gem install iruby


if [ -d "/vagrant" ]; then
    echo "Setting home user to: vagrant"
    HOME_USER=vagrant
else
    echo "Setting home user to: `SUDO_USER`"
    HOME_USER=`SUDO_USER`
fi

echo "# display last command and log it to bootstrap file
alias strap=\"history | tail -n2 | sed -n '1p'  | sed 's/^[0-9 ]*//' | sed 's/sudo //' >> /vagrant/bootstrap.sh\"
" >> /home/$HOME_USER/.bash_profile
apt-get install -y git-core
cd /opt && git clone http://www.github.com/gibiansky/IHaskell
apt-get install -y haskell-platform
/opt/IHaskell/ubuntu-install.sh
cabal install ihaskell
