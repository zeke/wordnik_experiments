require 'spec_helper'

describe "/words/index.html.erb" do
  include WordsHelper

  before(:each) do
    assigns[:words] = [
      stub_model(Word,
        :spelling => "value for spelling",
        :rank => 1
      ),
      stub_model(Word,
        :spelling => "value for spelling",
        :rank => 1
      )
    ]
  end

  it "renders a list of words" do
    render
    response.should have_tag("tr>td", "value for spelling".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
