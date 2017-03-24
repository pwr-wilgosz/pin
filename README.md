# README

###Install environment

* Instlall ruby 2.4.0 (recommended using ruby version manager, like RVM or RBenv)

* Go to the project directory

* Install gem bundler: `gem install bundler`

* Install dependencies: `bundle install`

###Running application

* run server: `rails s`
* visit application under `localhost:3000/search?value=anything`

### Stop application

* press CTRL+c in terminal window when app is running or type: `lsof -i TCP:3000 | grep ruby ` and `kill -9 PID` in other teminal session when PID is process id you'll see
