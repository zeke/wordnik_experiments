%w(rubygems hpricot nokogiri open-uri).each {|lib| require lib}

namespace :import do
	
  desc "Import wordcount words"
  task(:wordcount_words => :environment) do
    words = File.read(File.join(RAILS_ROOT, "../assets/lists/wordcount.org.txt"))
    words.each do |word|
      parts = word.chomp.downcase.split(",")
      word = Word.find_or_initialize_by_spelling(parts[0])
      word.rank = parts[1]
      word.save! if word.new_record?
      puts word.spelling
    end
  end
  
  desc "Import wiktionary words"
  task(:wiktionary_words => :environment) do
    spellings = File.read(File.join(RAILS_ROOT, "../assets/lists/wiktionary.txt"))
    spellings.each do |spelling|
      word = Word.find_or_create_by_spelling(spelling.chomp.downcase)
      puts word.spelling
    end
  end
  
  desc "Import recent wordnik favorites"
  task(:wordnik_favorites => :environment) do    
    puts "\n\nImporting recent wordnik favorites"
    doc = Nokogiri::XML(open('http://www.wordnik.com/favorites.xml'))
    doc.search('title').each do |title|
      word = Word.find_or_create_by_spelling(title.inner_html.chomp.downcase)
      puts word.spelling
    end
  end  
  
  desc "Import recent wordnik lookups"
  task(:wordnik_lookups => :environment) do    
    puts "\n\nImporting recent wordnik lookups"
    doc = Nokogiri::XML(open('http://www.wordnik.com/lookups.xml'))
    doc.search('title').each do |title|
      word = Word.find_or_create_by_spelling(title.inner_html.chomp.downcase)
      puts word.spelling
    end
  end  

  
end
