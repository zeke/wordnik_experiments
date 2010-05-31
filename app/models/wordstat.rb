class Wordstat < ActiveRecord::Base
  
  belongs_to :word

  validates_presence_of :word, :lookup_count, :favorite_count, :list_count, :comment_count

  after_create :update_cache_counts_on_word

  # Cache the count values in the word object itself..
  def update_cache_counts_on_word
    word.lookup_count = lookup_count
    word.favorite_count = favorite_count
    word.list_count = list_count
    word.comment_count = comment_count
    word.save
    true
  end
  
  def scrape_wordnik_site_for_count_data
    begin
      url = URI.encode "http://www.wordnik.com/words/#{word.spelling}"
      doc = open(url) { |f| Hpricot(f) }
    rescue
      return nil
    end
    
    stats_string = doc.search("#stats p").first.inner_html.strip_tags.remove_whitespace
    
    self.lookup_count = stats_string.match(/looked up (.*) times/i)[1].gnix(",").to_i rescue nil
    self.lookup_count = 0 if stats_string =~ /first person to look up this word/i
    self.lookup_count = 1 if stats_string =~ /looked up once/i
    self.lookup_count = 2 if stats_string =~ /looked up twice/i
    
    self.favorite_count = stats_string.match(/favorited (.*) times/i)[1].gnix(",").to_i rescue nil
    self.favorite_count = 1 if stats_string =~ /favorited once/i
    self.favorite_count = 2 if stats_string =~ /favorited twice/i
    
    self.list_count = stats_string.match(/listed (.*) times/i)[1].gnix(",").to_i rescue nil
    self.list_count = 1 if stats_string =~ /listed once/i
    self.list_count = 2 if stats_string =~ /listed twice/i
    
    self.comment_count = stats_string.match(/commented on (.*) times/i)[1].gnix(",").to_i rescue nil
    self.comment_count = 1 if stats_string =~ /commented on once/i
    self.comment_count = 2 if stats_string =~ /commented on twice/i
    true
  end
  
protected
  

  
end
