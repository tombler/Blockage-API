# reconfig timezone data? right now set to UTC
# dpkg-reconfigure tzdata

# !!!Offical PG repo doesn't work, see below
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# sudo apt-get install wget ca-certificates
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get install postgresql-9.6


sudo sh -c 'echo "deb http://ftp.debian.org/debian $(lsb_release -cs) main" > /etc/apt/sources.list.d/jessie.list'
sudo apt-get install debian-keyring debian-archive-keyring
sudo apt-get update
sudo apt-get install postgresql-9.4 # highest supported version as of 5/22/17
sudo apt-get install postgresql-contrib-9.4 #for uuid extension and other features

# log in as root, access postgres user
sudo su
su - postgres

# create a new PG user "tom" (or whatever user)
createuser --interactive
su - tom # or your username
createdb blockage # or your db name

# enter postgres client to make sure everything worked
psql blockage # or psql -U 'username' -d 'dbname'

# update node as root - https://github.com/nodesource/distributions
sudo su
curl -sL https://deb.nodesource.com/setup_7.x | bash -
apt-get install nodejs # runs apt-get update for you

# Clone repo
git clone xxxx.git
cd ./Blockage-API # project root
npm install

# Build db tables
bash build_db.sh


# Start the app & test locally
node ./bin/www
echo '{"extension_id": "31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee"}' | \
curl -d @- http://localhost:3000/api/1.0/extension --header "Content-Type:application/json"


