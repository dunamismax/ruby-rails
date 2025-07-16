require "spec_helper"

RSpec.describe SharedUtilities::ApiHelpers do
  describe ".generate_api_key" do
    it "generates an API key of default length" do
      key = described_class.generate_api_key
      expect(key.length).to eq(64)  # 32 * 2 (hex encoding)
    end
    
    it "generates an API key of specified length" do
      key = described_class.generate_api_key(16)
      expect(key.length).to eq(32)  # 16 * 2 (hex encoding)
    end
    
    it "generates unique keys" do
      key1 = described_class.generate_api_key
      key2 = described_class.generate_api_key
      expect(key1).not_to eq(key2)
    end
    
    it "generates keys with valid hex characters" do
      key = described_class.generate_api_key
      expect(key).to match(/\A[a-f0-9]+\z/)
    end
  end

  describe ".generate_password" do
    it "generates a password of default length" do
      password = described_class.generate_password
      expect(password.length).to eq(12)
    end
    
    it "generates a password of specified length" do
      password = described_class.generate_password(20)
      expect(password.length).to eq(20)
    end
    
    it "generates unique passwords" do
      password1 = described_class.generate_password
      password2 = described_class.generate_password
      expect(password1).not_to eq(password2)
    end
    
    it "generates passwords with valid characters" do
      password = described_class.generate_password
      valid_chars = /\A[0-9A-Za-z!@#$%^&*]+\z/
      expect(password).to match(valid_chars)
    end
    
    it "handles zero length" do
      password = described_class.generate_password(0)
      expect(password).to eq("")
    end
  end

  describe ".analyze_text" do
    let(:text) { "Hello world! This is a test. It has multiple sentences.\n\nThis is a second paragraph." }
    
    it "analyzes text correctly" do
      result = described_class.analyze_text(text)
      
      expect(result[:character_count]).to eq(text.length)
      expect(result[:character_count_no_spaces]).to eq(text.gsub(/\s/, '').length)
      expect(result[:word_count]).to eq(12)
      expect(result[:sentence_count]).to eq(3)
      expect(result[:paragraph_count]).to eq(2)
      expect(result[:avg_words_per_sentence]).to eq(4.0)
      expect(result[:reading_time]).to eq("1 min read")
    end
    
    it "handles empty text" do
      result = described_class.analyze_text("")
      
      expect(result[:character_count]).to eq(0)
      expect(result[:character_count_no_spaces]).to eq(0)
      expect(result[:word_count]).to eq(0)
      expect(result[:sentence_count]).to eq(0)
      expect(result[:paragraph_count]).to eq(0)
      expect(result[:avg_words_per_sentence]).to eq(0)
      expect(result[:reading_time]).to eq("1 min read")
    end
    
    it "handles nil input" do
      result = described_class.analyze_text(nil)
      expect(result).to eq({})
    end
    
    it "handles whitespace-only text" do
      result = described_class.analyze_text("   ")
      expect(result).to eq({})
    end
    
    it "handles single word" do
      result = described_class.analyze_text("Hello")
      
      expect(result[:character_count]).to eq(5)
      expect(result[:character_count_no_spaces]).to eq(5)
      expect(result[:word_count]).to eq(1)
      expect(result[:sentence_count]).to eq(0)
      expect(result[:paragraph_count]).to eq(1)
      expect(result[:avg_words_per_sentence]).to eq(0)
      expect(result[:reading_time]).to eq("1 min read")
    end
  end

  describe ".generate_random_number" do
    it "generates a number within default range" do
      number = described_class.generate_random_number
      expect(number).to be_between(1, 100)
    end
    
    it "generates a number within specified range" do
      number = described_class.generate_random_number(50, 60)
      expect(number).to be_between(50, 60)
    end
    
    it "handles same min and max" do
      number = described_class.generate_random_number(42, 42)
      expect(number).to eq(42)
    end
    
    it "handles negative numbers" do
      number = described_class.generate_random_number(-10, -5)
      expect(number).to be_between(-10, -5)
    end
    
    it "generates different numbers" do
      numbers = Array.new(10) { described_class.generate_random_number(1, 1000) }
      expect(numbers.uniq.length).to be > 1
    end
  end
end