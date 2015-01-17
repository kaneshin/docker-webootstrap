FROM centos:centos7

MAINTAINER Shintaro Kaneko <kaneshin0120@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y groupinstall "Development Tools";
RUN yum -y install git
RUN yum -y install mercurial
RUN yum -y install openssl-devel
RUN yum clean all


# Setup Node.js
# Install nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.22.2/install.sh | bash
RUN echo '[[ -s /root/.nvm/nvm.sh ]] && . /root/.nvm/nvm.sh && nvm use default' > /etc/profile.d/nvm.sh
RUN echo '. /root/.nvm/nvm.sh' | bash -l

# Install nodejs
RUN echo 'nvm install 0.10.32' | bash -l
RUN echo 'nvm alias default 0.10.32' | bash -l

# Install Bower & Gulp
RUN echo 'nvm use default' | bash -l
RUN echo 'npm install -g bower gulp' | bash -l


# Setup Ruby
# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN ./root/.rbenv/plugins/ruby-build/install.sh

RUN echo 'export PATH="/root/.rbenv/bin:$PATH"' >> /root/.bash_profile
ENV PATH /root/.rbenv/bin:$PATH

RUN echo 'eval "$(rbenv init -)"' > /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' | bash -l

# Install ruby
RUN echo 'rbenv install 2.1.5' | bash -l
RUN echo 'rbenv global 2.1.5' | bash -l

# Install Bundler for the version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN echo 'gem install bundler' | bash -l


# Setup Go
RUN mkdir -p /root/goroot && curl https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz | tar xvzf - -C /root/goroot --strip-components=1
RUN mkdir -p /root/gopath
RUN echo 'export GOROOT=/root/goroot' >> /root/.bash_profile
RUN echo 'export GOPATH=/root/gopath' >> /root/.bash_profile
RUN echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /root/.bash_profile
ENV GOROOT /root/goroot
ENV GOPATH /root/gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN echo 'go get github.com/revel/cmd/revel' | bash -l
RUN echo 'go get github.com/onsi/ginkgo/ginkgo' | bash -l
RUN echo 'go get github.com/onsi/gomega' | bash -l
RUN echo 'go get bitbucket.org/liamstask/goose/cmd/goose' | bash -l


# Setup MySQL (5.6.21)
WORKDIR /tmp
RUN wget http://downloads.mysql.com/archives/get/file/MySQL-5.6.21-1.el7.x86_64.rpm-bundle.tar
RUN tar -xvf MySQL-5.6.21-1.el7.x86_64.rpm-bundle.tar
RUN rpm -Uvh MySQL-client-5.6.21-1.el7.x86_64.rpm
RUN rpm -Uvh MySQL-server-5.6.21-1.el7.x86_64.rpm
WORKDIR /root


# Define default command.
CMD ["/bin/bash"]

