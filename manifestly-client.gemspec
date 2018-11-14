$LOAD_PATH.unshift("#{__dir__}/lib")
require 'manifestly/version'

Gem::Specification.new do |spec|
  spec.name          = 'manifestly-client'
  spec.version       = Manifestly::VERSION
  spec.licenses      = ['Apache-2.0']
  spec.authors       = ['Firespring']
  spec.email         = ['info.dev@firespring.com']

  spec.homepage      = 'https://github.com/firespring/manifestly-ruby'
  spec.summary       = 'Manifest.ly client library for ruby'
  spec.description   = 'A Ruby client that enables quick and easy interactions with the Manifest.ly api'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.15'
  spec.add_development_dependency 'bundler', '~> 1.7'
end
