require "spec_helper"

describe ChordQuality do
  context "associations" do
    it { should have_many(:chords) }
  end
  
  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
  end
  
  it "should expose #to_s as name" do
    described_class.new(:name => "Test").to_s.should == "Test"
  end
  
  it "should expose #resolve as an alias for find_by_name" do
    described_class.should_receive(:find_by_name).with("Major").once
    described_class.resolve("Major")
  end
  
  it "should expose hash access as an alias for find_by_name" do
    described_class.should_receive(:find_by_name).with("Major").once
    described_class["Major"]
  end
end
