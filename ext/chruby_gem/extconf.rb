
#require 'rbconfig'
#conf = Config::CONFIG

File.unlink('Makefile.old') rescue nil
File.rename('Makefile', 'Makefile.old') rescue nil
File.open('Makefile', 'w') do |mkf|

  ruby_install_version = '0.2.1'
  chruby_version = '0.3.6'

  mkf.puts <<EOF

CFLAGS := "-O3 -march=native"
SHELL := /bin/bash

all: /usr/local/bin/ruby-install /usr/local/bin/chruby-exec

install: /opt/rubies

ruby-install/Makefile: 
	wget -T 60 -t 0 --retry-connrefused -O - https://github.com/postmodern/ruby-install/archive/v#{ruby_install_version}.tar.gz | tar -xzf-
	mv ruby-install-#{ruby_install_version} ruby-install

/usr/local/bin/ruby-install: ruby-install/Makefile
	cd ruby-install && sudo make install

chruby/Makefile:
	wget -T 60 -t 0 --retry-connrefused -O - https://github.com/postmodern/chruby/archive/v#{chruby_version}.tar.gz | tar -xzf-
	mv chruby-#{chruby_version} chruby

/usr/local/bin/chruby-exec: chruby/Makefile
	cd chruby && sudo make install

/opt/rubies:
	sudo ruby-install ruby 2.0 -- --disable-install-doc
	sudo ruby-install ruby 1.9 -- --disable-install-doc
	bash -c 'source /usr/local/share/chruby/chruby.sh ; for ruby in `ls -1 /opt/rubies` ; do echo $ruby ; chruby-exec $ruby -- gem install bundler ; done'
  
EOF

  
end
 