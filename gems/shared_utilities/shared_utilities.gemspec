require_relative "lib/shared_utilities/version"

Gem::Specification.new do |spec|
  spec.name = "shared_utilities"
  spec.version = SharedUtilities::VERSION
  spec.authors = ["Dunamismax"]
  spec.email = ["noreply@dunamismax.dev"]
  spec.summary = "Shared utilities for Ruby Rails monorepo"
  spec.description = "A collection of shared utilities used across multiple applications in the Ruby Rails monorepo"
  spec.homepage = "https://github.com/dunamismax/ruby-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dunamismax/ruby-rails"
  spec.metadata["changelog_uri"] = "https://github.com/dunamismax/ruby-rails/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end