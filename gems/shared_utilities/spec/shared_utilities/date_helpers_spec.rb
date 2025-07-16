require "spec_helper"

RSpec.describe SharedUtilities::DateHelpers do
  describe ".time_ago_in_words" do
    let(:now) { Time.now }
    
    it "returns 'just now' for nil input" do
      expect(described_class.time_ago_in_words(nil)).to eq("just now")
    end
    
    it "returns 'just now' for recent time" do
      time = now - 30
      expect(described_class.time_ago_in_words(time)).to eq("just now")
    end
    
    it "returns minutes ago" do
      time = now - 300  # 5 minutes ago
      expect(described_class.time_ago_in_words(time)).to eq("5 minutes ago")
    end
    
    it "returns hours ago" do
      time = now - 7200  # 2 hours ago
      expect(described_class.time_ago_in_words(time)).to eq("2 hours ago")
    end
    
    it "returns days ago" do
      time = now - 172800  # 2 days ago
      expect(described_class.time_ago_in_words(time)).to eq("2 days ago")
    end
    
    it "returns months ago" do
      time = now - 5184000  # ~2 months ago
      expect(described_class.time_ago_in_words(time)).to eq("2 months ago")
    end
    
    it "returns years ago" do
      time = now - 63072000  # ~2 years ago
      expect(described_class.time_ago_in_words(time)).to eq("2 years ago")
    end
  end

  describe ".format_date" do
    let(:date) { Date.new(2023, 12, 25) }
    
    it "returns empty string for nil input" do
      expect(described_class.format_date(nil)).to eq("")
    end
    
    it "formats date with default format" do
      expect(described_class.format_date(date)).to eq("December 25, 2023")
    end
    
    it "formats date with short format" do
      expect(described_class.format_date(date, :short)).to eq("12/25/2023")
    end
    
    it "formats date with long format" do
      expect(described_class.format_date(date, :long)).to eq("December 25, 2023")
    end
    
    it "formats date with ISO format" do
      expect(described_class.format_date(date, :iso)).to eq("2023-12-25")
    end
    
    it "handles unknown format" do
      expect(described_class.format_date(date, :unknown)).to eq("December 25, 2023")
    end
    
    it "works with Time objects" do
      time = Time.new(2023, 12, 25, 10, 30, 45)
      expect(described_class.format_date(time, :short)).to eq("12/25/2023")
    end
  end
end