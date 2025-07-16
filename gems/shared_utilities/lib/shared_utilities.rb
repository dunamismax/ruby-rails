require_relative "shared_utilities/version"
require_relative "shared_utilities/string_helpers"
require_relative "shared_utilities/date_helpers"
require_relative "shared_utilities/api_helpers"
require_relative "shared_utilities/security_helpers"
require_relative "shared_utilities/cache_helpers"

module SharedUtilities
  class Error < StandardError; end
  class ValidationError < Error; end
  class SecurityError < Error; end
  class RateLimitError < Error; end
  class CacheError < Error; end
end