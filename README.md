# Basic rails5 install with Docker

How I built this app from scratch. Installs a specific version of rails: 5.2.4.3


# Setup files

Repo comes with the following files:

    Dockerfile_rails
    docker-compose.yml
    Gemfile  [created from a rails 5.4.2.3 install and modified a bit]
    docker-entrypoint-rails.sh

Keep a backup copy of this Gemfile because it will get altered when a new rails app is installed.

The following explains the edit done to the original Gemfile:

## Modify Gemfile

### disable sqlite3 and webpacker

At top since we want it to appear for development group:

	#gem 'sqlite3', "~> 1.4" 

Also disable webpacker at top if it's there:

   	#gem 'webpacker'
  
 
### add to this group:

	group :development, :test do
  		gem 'sqlite3', '1.4.2'
 
  		gem "debug", platforms: %i[ mri mingw x64_mingw ]

	end


### add production group:

	# I use heroku
	group :production do
  		gem 'pg', '1.2.3'
	end



# Installing 


## Rails install

### Run container to login to container:

	docker run --rm -v ${PWD}:/usr/src -w /usr/src -ti damireh/ruby2.7-node /bin/bash

### Run bundle (inside container)

	gem install rails -v '5.2.4.3' -V --no-document
	bundle config set --local without 'production'
	bundle install
	rails new . --skip-webpack-install

This may or may not cause conflicts with Gemfile. I chose yes to overwrite.

If Gemfile had conflict, then compare the new Gemfile to the old one. You will likely see it was just my edits noted earlier. Copy the old Gemfile back to replace the new one, and inside the container again run bundle install:

    bundle config set --local without 'production'
    bundle install

Exit and close container


### set permissions of new files to 775 and ownership to your user

'jj' is my user. This is needed not just for developing source but because docker may not build.

	sudo chmod -R 775 .

	sudo chown -R jj .


### (optional) add to .gitignore
For emacs

	*~
	.*~
	


# Set Postgres as DB instead of sqlite3

For heroku especially. Change database.yaml config to have "postgresql" for production. Name the database.



# run docker-compose build

	docker-compose build

# start the app

	docker-compose up


A warning from Ruby will be thrown. You can ignore it, but you won't get the standard output.

Go to http://192.168.4.100:3000/ which is the IP set for rails service in docker-compose.yml




# Github / Heroku setup

## Add to Github
	
This assumes source was already being added to git. And ssh key already checked in.

Follow github steps to create new branch main. But be sure to use SSH (NOT https) for auth. Example:
git remote add origin git@github.com:lacma2011/rails-react.git



For heroku, have to specify the node version in packages.json:
	  "engines" : { 
	    "npm" : "6.13.4",
    	    "node" : "12.14.1"
  	  },
  	  
Will have to get a version from a docker perhaps?



## Push to heroku

Assuming heroku command line app is already installed and I have an account already. Login and create new dyno and push to it:

	heroku login
	heroku create
	heroku buildpacks:add --index 1 heroku/nodejs
	heroku buildpacks:add --index 2 heroku/ruby
	heroku config:set NPM_CONFIG_PRODUCTION=false YARN_PRODUCTION=false

Then specify the right stack for ruby 2.7:

	heroku stack:set heroku-18

	git push heroku main

	
To see apps:

	heroku apps:info

Open homepage, which should be a custom 404 rails message since no route is set up for that yet.




