# -*- encoding: utf-8 -*-
load File.expand_path('lib/gdata/backup/version.rb', File.dirname(__FILE__))

Gem::Specification.new do |gem|
  gem.authors       = ['Joe Yates']
  gem.email         = ['joe.g.yates@gmail.com']
  gem.description   = 'Google Drive backup'
  gem.summary       = <<-EOT
Backup Google Drive documents as Open Document Format files.
  EOT
  gem.homepage      = 'https://github.com/joeyates/gdata-backup'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = 'gdata-backup'
  gem.require_paths = ['lib']
  gem.version       = Gdata::Backup::VERSION

  gem.add_runtime_dependency 'gdata'
  gem.add_runtime_dependency 'imap-backup'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-doc'
  gem.add_development_dependency 'rspec'
end

