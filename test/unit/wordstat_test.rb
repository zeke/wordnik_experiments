require 'test_helper'

class WordstatTest < ActiveSupport::TestCase

  context "A wordstat" do
    
    setup { @wordstat = Factory(:wordstat) }
    subject { @wordstat }
    
    should_belong_to :word
    should_validate_presence_of :word, :lookup_count, :favorite_count, :list_count, :comment_count
        
    should "scrape wordnik site for count data" do
      @word = Factory(:word, :spelling => "dog")
      @wordstat = @word.wordstats.new
      assert !@wordstat.valid?
      assert @wordstat.scrape_wordnik_site_for_count_data
      assert @wordstat.save!
    end
    
  end

  

end