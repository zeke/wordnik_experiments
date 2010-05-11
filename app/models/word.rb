class Word < ActiveRecord::Base
  
  has_many :wordstats, :dependent => :destroy
    
  validates_uniqueness_of :spelling
    
  def has_wordstats?
    stat_attributes = %w(lookup_count favorite_count list_count comment_count)
    stat_attributes.any? {|a| a.present? }
  end
  
end
