require "spec_helper"

describe ChordScale do
  context "associations" do
    it { should belong_to(:chord) }
    it { should belong_to(:mode) }
  end
  
  context "delegations" do
    it "should delegate scale to mode"
    it "should delegate key to chord"
  end
end
