# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','weblogin_config.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'weblogin'
  s.version = Weblogin::VERSION
  s.author = 'Zhang Ganggang'
  s.email = 'just_send@163.com'
  s.homepage = 'http://weibo.com/jstdoit'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Client for Beijing Technology and Business Web Login'
# Add your other files here if you make them
  s.files = %w(
bin/weblogin
lib/command.rb
lib/exceptions.rb
lib/weblogin.rb
lib/weblogin_config.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','weblogin.rdoc']
  s.rdoc_options << '--title' << 'weblogin' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'weblogin'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli')
end
