%w(rubygems hpricot).each {|lib| require lib}

namespace :import do
	
  desc "Import words"
  task(:words => :environment) do
    words = File.read(File.join(RAILS_ROOT, "db/wordlists/wordcount.org.txt"))
    words.each do |word|
      parts = word.chomp.downcase.split(",")
      word = Word.find_or_initialize_by_spelling(parts[0])
      word.rank = parts[1]
      word.save! if word.new_record?
      puts word.spelling
    end
  end
      
  task(:wordstats => :environment) do
    words = Word.find(:all, :include => [:wordstats])
    
    # An array for storing words that don't get saved
    problem_words = []
    
    words.each do |word|
      
      # TEMPORARY: Skip word if it's already got stats
      unless word.wordstats.blank?
        puts "Skipping #{word.spelling}"
        next
      end
      
      url = "http://www.wordnik.com/words/#{word.spelling}"
      doc = open(url) { |f| Hpricot(f) }
      next unless doc

      wordstat = word.wordstats.new
      stats_string = doc.search("#stats p").first.inner_html.strip_tags.remove_whitespace      
      # puts stats_string
      
      wordstat.lookup_count = stats_string.match(/looked up (.*) times/i)[1].gnix(",").to_i rescue nil
      wordstat.looked_count = 1 if stats_string =~ /looked up once/i
      wordstat.looked_count = 2 if stats_string =~ /looked up twice/i
      
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
        puts "PROBLEM ------------------------- #{word.spelling}"
        problem_words << word.spelling
      end
    end
    
    puts "\nDone. Words with problems: #{problem_words.join(", ")}"
  end

  
  
end
