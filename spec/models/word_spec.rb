require 'spec_helper'

describe Word do
  before(:each) do
    @valid_attributes = {
      :spelling => "value for spelling",
      :rank => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Word.create!(@valid_attributes)
  end
end
