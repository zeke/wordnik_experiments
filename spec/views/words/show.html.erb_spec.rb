require 'spec_helper'

describe "/words/show.html.erb" do
  include WordsHelper
  before(:each) do
    assigns[:word] = @word = stub_model(Word,
      :spelling => "value for spelling",
      :rank => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ spelling/)
    response.should have_text(/1/)
  end
end
