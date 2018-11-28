#!/bin/bash

adddate() {
    while IFS= read -r line; do
        echo "$(date) $line"
    done
}

APP_USER=app
APP_HOME=${APP_HOME:-"/var/www/html"}
APP_VERSION=${APP_VERSION/#/-}


echo "# Starting up container..." | adddate >> $APP_HOME/log/startup.log

su -c "chown -R $APP_USER:$APP_USER $BUNDLE_PATH" app
su -c "chown -R $APP_USER:$APP_USER /home/app" app
su -c "mkdir -p $APP_HOME/tmp/pids" app

su -c "bundle config --local path $BUNDLE_PATH >> $APP_HOME/log/startup.log 2>&1" $APP_USER
su -c "bundle check || bundle install >> $APP_HOME/log/startup.log 2>&1" $APP_USER

# su -c "bundle exec rake db:migrate >> $APP_HOME/log/db_migrate.log 2>&1" app


/sbin/my_init
