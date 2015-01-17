FROM centos:centos7

MAINTAINER Shintaro Kaneko <kaneshin0120@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y groupinstall "Development Tools";
RUN yum -y install git
RUN yum -y install mercurial
RUN yum clean all

ENV PROFILE ~/.bash_profile


# Setup Node.js

# Install nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.22.2/install.sh | bash

# Install nodejs
ENV NODE_VERSION v0.10.32
RUN nvm install $(NODE_VERSION)
RUN echo 'nvm alias default $(NODE_VERSION)' >> $(PROFILE)
RUN echo 'nvm use default' >> $(PROFILE)

# Install Bower & Gulp
RUN npm install -g bower gulp


# Setup Ruby

# Install rbenv
ENV RBENV_REPO https://github.com/sstephenson/rbenv.git
ENV RBENV_DEST ~/.rbenv
RUN git clone $(RBENV_REPO) $(RBENV_DEST)
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $(PROFILE)
RUN echo 'eval "$(rbenv init -)"' >> $(PROFILE)

# Install ruby-build
ENV RUBY_BUILD_REPO https://github.com/sstephenson/ruby-build.git
RUN git clone $(RUBY_BUILD_REPO) $(RBENV_DEST)/plugins/ruby-build

# Install ruby
ENV RUBY_VERSION 2.1.5
RUN rbenv install $(RUBY_VERSION)
RUN rbenv global $(RUBY_VERSION)

# Install bundler
RUN gem install bundler


# Setup Go

ENV GOLANG_VERSION 1.3.3
ENV GOROOT ~/goroot
ENV GOPATH ~/gopath
RUN mkdir -p $(GOROOT) && curl https://storage.googleapis.com/golang/go$(GOLANG_VERSION).linux-amd64.tar.gz | tar xvzf - -C $(GOROOT) --strip-components=1
RUN mkdir -p $(GOPATH)
RUN echo 'export GOROOT=$(GOROOT)' >> $(PROFILE)
RUN echo 'export GOPATH=$(GOPATH)' >> $(PROFILE)
RUN echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $(PROFILE)


# Define default command.
CMD ["/bin/bash"]

