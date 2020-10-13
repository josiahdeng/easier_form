$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "easier_form/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "easier_form"
  spec.version     = EasierForm::VERSION
  spec.authors     = ["lucian"]
  spec.email       = ["17607003651@163.com"]
  spec.homepage    = "https://github.com/josiahdeng"
  spec.summary     = "form generator"
  spec.description = "copy simple_form"
  spec.license     = "MIT"

  spec.files = Dir["MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "activemodel", ">= 5.0"
  spec.add_dependency "actionpack", ">= 5.0"
end
