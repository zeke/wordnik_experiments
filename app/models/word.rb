class Word < ActiveRecord::Base
  
  has_many :wordstats, :dependent => :destroy

  validates_presence_of :spelling
  validates_uniqueness_of :spelling
    
  validate :matches_regex

  def has_wordstats?
    stat_attributes = %w(lookup_count favorite_count list_count comment_count)
    stat_attributes.any? {|a| a.present? }
  end

  # Accepts an array of words
  named_scope :in_list, lambda { |list| { :conditions => ['spelling IN (:list)', {:list => list}] } }

  named_scope :having_wordstats, :conditions => ["lookup_count IS NOT NULL AND favorite_count IS NOT NULL AND list_count IS NOT NULL AND comment_count IS NOT NULL"]
  
  named_scope :missing_wordstats, :conditions => {
    :lookup_count => nil,
    :favorite_count => nil,
    :list_count => nil,
    :comment_count => nil
  }
  
  def self.regex
    /^[\w|\'\-]+$/
  end

protected

	def matches_regex
    return true unless (self.spelling =~ Word.regex).nil?
		errors.add_to_base "Spelling contains non-word characters."
		return false
	end

  
end
