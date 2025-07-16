require_relative "blog_generator/version"
require_relative "blog_generator/cli"
require "shared_utilities"

module BlogGenerator
  class Error < StandardError; end
end