# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-buzz_study"
  spec.version       = "0.0.1"
  spec.authors       = ["ryonext"]
  spec.email         = ["ryonext.s@gmail.com"]
  spec.summary       = %q{Create data for buzz_study.}
  spec.description   = %q{Create data for buzz_study.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "mongo", "1.8.6"
  spec.add_runtime_dependency "bson_ext"
  spec.add_runtime_dependency "httpclient"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "fluentd", "~> 0.10.17"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
