class Wordstat < ActiveRecord::Base
  
  belongs_to :word
  
  after_create :update_cache_counts_on_word

  # Save values to word object itself for performance reasons..  
  def update_cache_counts_on_word
    word.lookup_count = lookup_count
    word.favorite_count = favorite_count
    word.list_count = list_count
    word.comment_count = comment_count
    word.save
    true
  end
  
end
