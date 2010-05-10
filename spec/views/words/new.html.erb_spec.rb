require 'spec_helper'

describe "/words/new.html.erb" do
  include WordsHelper

  before(:each) do
    assigns[:word] = stub_model(Word,
      :new_record? => true,
      :spelling => "value for spelling",
      :rank => 1
    )
  end

  it "renders new word form" do
    render

    response.should have_tag("form[action=?][method=post]", words_path) do
      with_tag("input#word_spelling[name=?]", "word[spelling]")
      with_tag("input#word_rank[name=?]", "word[rank]")
    end
  end
end
