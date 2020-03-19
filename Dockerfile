ARG RUBY_PATH=/usr/local
ARG RUBY_VERSION=2.6.4

FROM kickykarthik/centos-base:7 AS rubybuild
ARG RUBY_PATH
ARG RUBY_VERSION
RUN git clone git://github.com/rbenv/ruby-build.git $RUBY_PATH/plugins/ruby-build \
&&  $RUBY_PATH/plugins/ruby-build/install.sh
RUN ruby-build $RUBY_VERSION $RUBY_PATH/

FROM centos:7
LABEL maintainer "Karthik(kicky)"
ARG RUBY_PATH
ENV PATH $RUBY_PATH/bin:$PATH
RUN yum -y install \
        epel-release \
        make \
        gcc \
        git \
        openssl-devel \
        zlib-devel \
        mysql-devel \
        redis \
        sqlite-devel
RUN rpm -Uvh http://repo.rundeck.org/latest.rpm
RUN yum install -y rundeck
COPY --from=rubybuild $RUBY_PATH $RUBY_PATH


RUN gem update --system
RUN gem install bundler activerecord net-http2 safe_yaml nokogiri crack uuid aws-sdk
