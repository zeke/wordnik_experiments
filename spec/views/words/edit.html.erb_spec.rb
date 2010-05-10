require 'spec_helper'

describe "/words/edit.html.erb" do
  include WordsHelper

  before(:each) do
    assigns[:word] = @word = stub_model(Word,
      :new_record? => false,
      :spelling => "value for spelling",
      :rank => 1
    )
  end

  it "renders the edit word form" do
    render

    response.should have_tag("form[action=#{word_path(@word)}][method=post]") do
      with_tag('input#word_spelling[name=?]', "word[spelling]")
      with_tag('input#word_rank[name=?]', "word[rank]")
    end
  end
end
