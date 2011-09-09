require "spec_helper"

describe Form do
  context "associations" do
    it { should have_many(:progressions) }
    it { should have_many(:tunes) }
  end
  
  context "validations" do
    it { should validate_presence_of(:name) }
  end
  
  it "should expose #resolve as find_by_name" do
    described_class.should_receive(:find_by_name).with("Blues").once
    described_class.resolve("Blues")
  end
end
