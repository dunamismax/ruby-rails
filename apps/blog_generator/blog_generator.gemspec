require_relative "lib/blog_generator/version"

Gem::Specification.new do |spec|
  spec.name = "blog_generator"
  spec.version = BlogGenerator::VERSION
  spec.authors = ["Dunamismax"]
  spec.email = ["noreply@dunamismax.dev"]
  spec.summary = "CLI tool for generating blog posts"
  spec.description = "A command-line tool for generating blog post templates with metadata"
  spec.homepage = "https://github.com/dunamismax/ruby-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dunamismax/ruby-rails"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["blog_generator"]
  spec.require_paths = ["lib"]

  spec.add_dependency "shared_utilities", path: "../../gems/shared_utilities"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end