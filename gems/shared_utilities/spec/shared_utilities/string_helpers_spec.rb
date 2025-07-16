require "spec_helper"

RSpec.describe SharedUtilities::StringHelpers do
  describe ".slugify" do
    it "converts text to a slug" do
      expect(described_class.slugify("Hello World")).to eq("hello-world")
    end
    
    it "handles special characters" do
      expect(described_class.slugify("Hello, World!")).to eq("hello-world")
    end
    
    it "handles multiple spaces" do
      expect(described_class.slugify("Hello   World")).to eq("hello-world")
    end
    
    it "handles leading and trailing spaces" do
      expect(described_class.slugify("  Hello World  ")).to eq("hello-world")
    end
    
    it "handles empty string" do
      expect(described_class.slugify("")).to eq("")
    end
    
    it "handles nil input" do
      expect(described_class.slugify(nil)).to eq("")
    end
    
    it "handles numbers" do
      expect(described_class.slugify("Hello World 123")).to eq("hello-world-123")
    end
    
    it "handles unicode characters" do
      expect(described_class.slugify("Café résumé")).to eq("caf-r-sum")
    end
  end

  describe ".truncate_words" do
    let(:text) { "This is a long sentence with many words that should be truncated." }
    
    it "truncates text to specified word count" do
      result = described_class.truncate_words(text, 5)
      expect(result).to eq("This is a long sentence...")
    end
    
    it "returns original text if word count is less than limit" do
      result = described_class.truncate_words("Short text", 10)
      expect(result).to eq("Short text")
    end
    
    it "handles empty string" do
      expect(described_class.truncate_words("", 5)).to eq("")
    end
    
    it "handles nil input" do
      expect(described_class.truncate_words(nil, 5)).to eq("")
    end
    
    it "handles zero word count" do
      expect(described_class.truncate_words(text, 0)).to eq("...")
    end
    
    it "handles negative word count" do
      expect(described_class.truncate_words(text, -1)).to eq("...")
    end
  end

  describe ".reading_time" do
    it "calculates reading time for text" do
      text = "word " * 200  # 200 words
      expect(described_class.reading_time(text)).to eq("1 min read")
    end
    
    it "calculates reading time for longer text" do
      text = "word " * 600  # 600 words
      expect(described_class.reading_time(text)).to eq("3 min read")
    end
    
    it "handles empty string" do
      expect(described_class.reading_time("")).to eq("1 min read")
    end
    
    it "handles nil input" do
      expect(described_class.reading_time(nil)).to eq("1 min read")
    end
    
    it "handles single word" do
      expect(described_class.reading_time("word")).to eq("1 min read")
    end
  end

  describe ".highlight_code" do
    it "highlights code with default language" do
      code = "puts 'Hello, World!'"
      result = described_class.highlight_code(code)
      expect(result).to eq('<pre class="highlight ruby"><code>puts \'Hello, World!\'</code></pre>')
    end
    
    it "highlights code with specified language" do
      code = "console.log('Hello, World!');"
      result = described_class.highlight_code(code, "javascript")
      expect(result).to eq('<pre class="highlight javascript"><code>console.log(\'Hello, World!\');</code></pre>')
    end
    
    it "handles empty code" do
      result = described_class.highlight_code("")
      expect(result).to eq('<pre class="highlight ruby"><code></code></pre>')
    end
    
    it "handles nil code" do
      result = described_class.highlight_code(nil)
      expect(result).to eq('<pre class="highlight ruby"><code></code></pre>')
    end
    
    it "escapes HTML characters" do
      code = "<script>alert('xss')</script>"
      result = described_class.highlight_code(code)
      expect(result).to eq('<pre class="highlight ruby"><code><script>alert(\'xss\')</script></code></pre>')
    end
  end
end