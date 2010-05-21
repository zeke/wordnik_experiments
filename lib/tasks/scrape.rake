%w(rubygems hpricot).each {|lib| require lib}

namespace :scrape do

  desc "Import wordstats for words that don't yet have any."
  task(:missing_wordstats => :environment) do

    # An array for storing words that don't get saved
    problem_words = []
    
    Word.missing_wordstats.each do |word|
      
      begin
        url = URI.encode "http://www.wordnik.com/words/#{word.spelling}"
        doc = open(url) { |f| Hpricot(f) }
      rescue
        next
      end
      next unless doc

      wordstat = word.wordstats.new
      stats_string = doc.search("#stats p").first.inner_html.strip_tags.remove_whitespace      
      # puts stats_string
      
      wordstat.lookup_count = stats_string.match(/looked up (.*) times/i)[1].gnix(",").to_i rescue nil
      wordstat.lookup_count = 0 if stats_string =~ /first person to look up this word/i
      wordstat.lookup_count = 1 if stats_string =~ /looked up once/i
      wordstat.lookup_count = 2 if stats_string =~ /looked up twice/i
      
      wordstat.favorite_count = stats_string.match(/favorited (.*) times/i)[1].gnix(",").to_i rescue nil
      wordstat.favorite_count = 1 if stats_string =~ /favorited once/i
      wordstat.favorite_count = 2 if stats_string =~ /favorited twice/i
      
      wordstat.list_count = stats_string.match(/listed (.*) times/i)[1].gnix(",").to_i rescue nil
      wordstat.list_count = 1 if stats_string =~ /listed once/i
      wordstat.list_count = 2 if stats_string =~ /listed twice/i
      
      wordstat.comment_count = stats_string.match(/commented on (.*) times/i)[1].gnix(",").to_i rescue nil
      wordstat.comment_count = 1 if stats_string =~ /commented on once/i
      wordstat.comment_count = 2 if stats_string =~ /commented on twice/i
      
      if wordstat.save
        puts "#{word.spelling} -> #{wordstat.lookup_count} lookups"
      else
        puts "PROBLEM ------------------------------------------- #{word.spelling}"
        problem_words << word.spelling
      end
    end
    
    puts "\nDone. Words with problems: #{problem_words.join(", ")}"
  end
  
end
