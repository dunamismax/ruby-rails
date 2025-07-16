class HomeController < ApplicationController
  def index
    @apis = [
      {
        name: "Text Analyzer",
        description: "Analyze text for various statistics like word count, reading time, and more",
        endpoint: "/api/text/analyze",
        example: "POST /api/text/analyze with { text: 'Your text here' }"
      },
      {
        name: "Random Number Generator",
        description: "Generate random numbers within specified ranges",
        endpoint: "/api/random/number",
        example: "GET /api/random/number?min=1&max=100"
      },
      {
        name: "Password Generator",
        description: "Generate secure passwords with customizable length and complexity",
        endpoint: "/api/password/generate",
        example: "GET /api/password/generate?length=12"
      },
      {
        name: "API Key Generator",
        description: "Generate secure API keys for your applications",
        endpoint: "/api/keys/generate",
        example: "GET /api/keys/generate?length=32"
      },
      {
        name: "String Utilities",
        description: "Various string manipulation utilities like slugification and truncation",
        endpoint: "/api/string/slugify",
        example: "POST /api/string/slugify with { text: 'Hello World' }"
      },
      {
        name: "Date Utilities",
        description: "Format dates and calculate relative time",
        endpoint: "/api/date/format",
        example: "POST /api/date/format with { date: '2023-12-25', format: 'long' }"
      }
    ]
  end
end