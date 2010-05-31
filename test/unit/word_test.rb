require 'test_helper'

class WordTest < ActiveSupport::TestCase

  context "A word" do
    
    setup { @word = Factory(:word) }
    subject { @word }
    
    should_validate_presence_of :spelling
    should_validate_uniqueness_of :spelling
    should_have_many :wordstats
    
    should "not allow spellings with unwordly characters" do
      @word.spelling = "!bang"
      assert !@word.valid?
      assert_contains @word.errors.on_base, /spelling contains non/i
      
      @word.spelling = "why?"
      assert !@word.valid?
      assert_contains @word.errors.on_base, /spelling contains non/i
      
      @word.spelling = "GOOD"
      assert @word.valid?
    end
    
  end

  

end