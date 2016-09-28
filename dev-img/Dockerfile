################################################################################
# The goal of this container is to provide a VA Appeals specific dev
# environment that includes all the basic tools (e.g. Ruby, git, curl, ...)
# It is intended to be used like a VM, and not a typical app container.
#
################################################################################
FROM ubuntu:16.04

################################################################################
# Basic development packages and tools
################################################################################
RUN apt-get update && apt-get install -y \
	sudo \
	git \
	curl \
	grep \
	tar \
	ssh \
	nano \
	build-essential \
	gedit \
	autoconf \
	zlib1g-dev \
	openssl \
	libssl-dev \
	libpq-dev \
	iputils-ping \
	netcat \
	libsqlite3-dev \
	pdftk \
	chrpath \
	libxft-dev

################################################################################
# Phantom JS
################################################################################
ENV PHANTOM_JS phantomjs-2.1.1-linux-x86_64
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64 /usr/local/share
RUN ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

################################################################################
# Ruby 2.3, copied from the Ruby Dockerhub (https://hub.docker.com/_/ruby/)
################################################################################

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.1
ENV RUBY_DOWNLOAD_SHA256 b87c738cb2032bf4920fef8e3864dc5cf8eae9d89d8d523ce0236945c5797dcd
ENV RUBYGEMS_VERSION 2.6.6

# some of ruby's build scripts are written in ruby
#   we purge system ruby later to make sure our final image uses what we just built
RUN set -ex \
	\
	&& buildDeps=' \
		bison \
		libgdbm-dev \
		ruby \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& wget -O ruby.tar.gz "https://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
	&& echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
	\
	&& mkdir -p /usr/src/ruby \
	&& tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.gz \
	\
	&& cd /usr/src/ruby \
	\
# hack in "ENABLE_PATH_CHECK" disabling to suppress:
#   warning: Insecure world writable dir
	&& { \
		echo '#define ENABLE_PATH_CHECK 0'; \
		echo; \
		cat file.c; \
	} > file.c.new \
	&& mv file.c.new file.c \
	\
	&& autoconf \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& make install \
	\
	&& apt-get purge -y --auto-remove $buildDeps \
	&& cd / \
	&& rm -r /usr/src/ruby \
	\
	&& gem update --system "$RUBYGEMS_VERSION"

ENV BUNDLER_VERSION 1.13.1

RUN gem install bundler --version "$BUNDLER_VERSION"

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

COPY instantclient_12_1/ /opt/oracle/instantclient_11_2
RUN ln -s /opt/oracle/instantclient_11_2/libclntsh.dylib.11.1 /opt/oracle/instantclient_11_2/libclntsh.dylib

################################################################################
# Create User askldjd
################################################################################
RUN useradd -ms /bin/bash askldjd
RUN usermod -g users askldjd
RUN usermod -a -G users askldjd
RUN echo "askldjd:users" | chpasswd && adduser askldjd sudo
RUN echo "askldjd ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
ENV HOME /home/askldjd
WORKDIR /home/askldjd

################################################################################
# Git
################################################################################
RUN git config --global user.email "chun.ning@va.gov"
RUN git config --global user.name "Ning, Alan"
RUN git config --global push.default simple

################################################################################
# Permissions and Paths
################################################################################
RUN ln -s /work/ /home/askldjd/work
COPY git-completion.bash /home/askldjd/git-completion.bash
COPY ssh /home/askldjd/.ssh
COPY bashrc /home/askldjd/.bashrc
RUN chown -R askldjd:users /home/askldjd/

USER askldjd


ENV TERM=xterm

# Expose the Appeals Caseflow efolder express port number
EXPOSE 3000
