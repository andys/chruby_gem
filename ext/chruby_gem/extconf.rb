
#require 'rbconfig'
#conf = Config::CONFIG

File.unlink('Makefile.old') rescue nil
File.rename('Makefile', 'Makefile.old') rescue nil
File.open('Makefile', 'w') do |mkf|

  ruby_install_version = '0.2.1'
  chruby_version = '0.3.6'
  rubies = ['1.9', '2.0']

  mkf.puts <<EOF

CFLAGS := "-O3 -march=native"
SHELL := /bin/bash

all: /usr/local/bin/ruby-install /usr/local/bin/chruby-exec

install: /opt/rubies

ruby-install/Makefile: 
	wget -T 60 -t 0 --retry-connrefused -O - https://github.com/postmodern/ruby-install/archive/v#{ruby_install_version}.tar.gz | tar -xzf-
	mv ruby-install-#{ruby_install_version} ruby-install

/usr/local/bin/ruby-install: ruby-install/Makefile
	cd ruby-install && make install

chruby/Makefile:
	wget -T 60 -t 0 --retry-connrefused -O - https://github.com/postmodern/chruby/archive/v#{chruby_version}.tar.gz | tar -xzf-
	mv chruby-#{chruby_version} chruby

/usr/local/bin/chruby-exec: chruby/Makefile
	cd chruby && make install

EOF


  mkf.puts '/opt/rubies:'
  ['1.9', '2.0'].each {|ruby|  mkf.puts "\truby-install ruby #{ruby} -- --disable-install-doc" }
  ['1.9', '2.0'].each {|ruby|  mkf.puts "\tsource /usr/local/share/chruby/chruby.sh ; chruby #{ruby} ; gem install bundler" }
  
end
 