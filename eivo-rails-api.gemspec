$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'eivo-rails-api'
  spec.version       = '0.0.7'
  spec.authors       = ['Jonathan VUKOVICH-TRIBOUHARET']
  spec.email         = ['jonathan@eivo.co']

  spec.summary       = 'EIVO Rails API'
  spec.description   = 'EIVO Rails API'
  spec.homepage      = 'https://www.eivo.co'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0")
  end
  spec.executables << 'eivo'
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'

  spec.add_dependency 'oj'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'fast_jsonapi'

  spec.add_dependency 'kaminari'

  spec.add_dependency 'sentry-raven'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
