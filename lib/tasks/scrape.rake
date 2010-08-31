%w(rubygems hpricot).each {|lib| require lib}

namespace :scrape do

  desc "Import wordstats for (1000) words that don't yet have any."
  task(:missing_wordstats => :environment) do

    puts "\n\nImporting wordstats for (1000) words that don't yet have any."

    # An array for storing words that don't get saved
    problem_words = []
    
    Word.missing_wordstats.find(:all, :limit => 1000).each do |word|
      wordstat = word.wordstats.new
      wordstat.scrape_wordnik_site_for_count_data

      if wordstat.save
        puts "#{word.spelling} -> #{wordstat.lookup_count} lookups"
      else
        problem_words << word.spelling
      end
    end
    
    puts "\nDone #{Time.now}. Words with problems: #{problem_words.join(", ")}"
  end
  
end