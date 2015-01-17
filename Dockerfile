FROM centos:centos7

MAINTAINER Shintaro Kaneko <kaneshin0120@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y groupinstall "Development Tools";
RUN yum -y install git
RUN yum -y install mercurial
RUN yum clean all

RUN useradd docker
USER docker
WORKDIR /home/docker

# Setup Node.js
# Install nvm
RUN git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
RUN echo '[ -f ~/.nvm/nvm.sh ] && source ~/.nvm/nvm.sh' >> ~/.bashrc
RUN source ~/.nvm/nvm.sh

# Install nodejs
RUN nvm install v0.10.32
RUN echo 'nvm alias default v0.10.32' >> ~/.bash_profile
RUN echo 'nvm use default' >> ~/.bash_profile
RUN nvm alias default v0.10.32
RUN nvm use default

# Install Bower & Gulp
RUN npm install -g bower gulp


# Setup Ruby
# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN export PATH="$HOME/.rbenv/bin:$PATH"
RUN eval "$(rbenv init -)"

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install ruby
RUN rbenv install 2.1.5
RUN rbenv global 2.1.5

# Install bundler
RUN gem install bundler


# Setup Go
RUN mkdir -p ~/goroot && curl https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz | tar xvzf - -C ~/goroot --strip-components=1
RUN mkdir -p ~/gopath
RUN echo 'export GOROOT=~/goroot' >> ~/.bash_profile
RUN echo 'export GOPATH=~/gopath' >> ~/.bash_profile
RUN echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bash_profile
RUN export GOROOT=~/goroot
RUN export GOPATH=~/gopath
RUN export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN go get github.com/revel/cmd/revel
RUN go get github.com/onsi/ginkgo/ginkgo
RUN go get github.com/onsi/gomega
RUN go get bitbucket.org/liamstask/goose/cmd/goose


# Define default command.
CMD ["/bin/bash"]

