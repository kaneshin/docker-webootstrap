FROM centos:centos7

MAINTAINER Shintaro Kaneko <kaneshin0120@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y groupinstall "Development Tools";
RUN yum -y install git
RUN yum -y install mercurial
RUN yum clean all


# Setup Node.js

# Install nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.22.2/install.sh | bash

# Install nodejs
RUN nvm install v0.10.32
RUN echo 'nvm alias default v0.10.32' >> ~/.bash_profile
RUN echo 'nvm use default' >> ~/.bash_profile

# Install Bower & Gulp
RUN npm install -g bower gulp


# Setup Ruby

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install ruby
RUN rbenv install 2.1.5
RUN rbenv global 2.1.5

# Install bundler
RUN gem install bundler


# Setup Go

ENV GOLANG_VERSION 1.3.3
ENV GOROOT ~/goroot
ENV GOPATH ~/gopath
RUN mkdir -p ~/goroot && curl https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz | tar xvzf - -C ~/goroot --strip-components=1
RUN mkdir -p ~/gopath
RUN echo 'export GOROOT=~/goroot' >> ~/.bash_profile
RUN echo 'export GOPATH=~/gopath' >> ~/.bash_profile
RUN echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bash_profile


# Define default command.
CMD ["/bin/bash"]

