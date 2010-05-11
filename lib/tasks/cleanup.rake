%w(rubygems).each {|lib| require lib}

namespace :cleanup do
	
  desc "Remove words that have duplicates"
  task(:duplicate_words => :environment) do
    words = Word.all

    # Destroy all words that don't yet have stats (they will be re-imported)
    words.each do |word|
      word.destroy unless word.has_wordstats?
    end
    
    # Refresh the word list
    words = Word.all
    dup_spellings = words.map(&:spelling).dups
    deleted_dup_spellings = []
    dups = words.select {|word| dup_spellings.include?(word.spelling) }    
    
    # Destroy all words whose duplicated hasn't already been deleted..
    dups.each do |word|
      next if deleted_dup_spellings.include?(word.spelling)
      puts "Deleting #{word.spelling}"
      deleted_dup_spellings << word.spelling
      word.destroy
    end
    
  end

end