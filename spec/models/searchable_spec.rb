require "spec_helper"

describe Searchable do
  describe "associations" do
    it { should belong_to(:model) }
    it { should belong_to(:parent) }
    it { should have_many(:children) }
  end

  describe "#to_s" do
    it "should expose display_name if display_name is set" do
      described_class.new(:display_name => "Display", :name => "Original").tap do |s|
        s.to_s.should == "Display"
      end
    end

    it "should expose name if display_name is not set" do
      described_class.new(:name => "Original").tap do |s|
        s.to_s.should == "Original"
      end
    end
  end
end

