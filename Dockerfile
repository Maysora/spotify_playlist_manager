FROM ruby:2.4

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && apt-get install -y nodejs

# set encoding
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE C.UTF-8

ENV GEM_PATH /gemcache
ENV BUNDLE_PATH /gemcache
ENV APP_HOME /my_app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
