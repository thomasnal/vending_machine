FROM phusion/passenger-ruby25 AS devel
MAINTAINER Thomas Nalevajko <thomas.nalevajko@gmail.com>

ENV DOCKERFILE_PATH .docker
ENV APP_USER app
ENV APP_HOME /var/www/html


# Enable webserver
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD $DOCKERFILE_PATH/nginx.conf /etc/nginx/sites-enabled/app.conf
ADD $DOCKERFILE_PATH/nginx-env.conf /etc/nginx/main.d/app-env.conf


# Install chrome and supporting utilities
RUN apt-get update && apt-get install \
  -y --no-install-recommends \
  unzip wget

# Add Chrome package source
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chromedriver
RUN wget -q https://chromedriver.storage.googleapis.com/2.39/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin
RUN rm -f chromedriver_linux64.zip



# Install system packages
RUN apt-get update && apt-get install \
  -y --no-install-recommends \
  google-chrome-stable \
  postgresql-client \
  sudo && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "$APP_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/app


# Persist bundle
ENV BUNDLE_PATH /bundle
RUN mkdir $BUNDLE_PATH
RUN chown -R $APP_USER:$APP_USER $BUNDLE_PATH


# Persist 'app' user home for commands history, etc.
VOLUME /home/app
RUN chown -R $APP_USER:$APP_USER /home/app


USER $APP_USER
RUN gem install bundler
RUN gem install rails
RUN gem install rspec
RUN gem install spring
RUN gem install rubocop
USER root

WORKDIR $APP_HOME

COPY $DOCKERFILE_PATH/entrypoint.sh /
CMD ["/entrypoint.sh"]


FROM devel

# Copy source code
COPY . $APP_HOME
RUN chown -R $APP_USER:$APP_USER $APP_HOME

USER $APP_USER
RUN bundle config --local path $BUNDLE_PATH
RUN bundle install
USER root
