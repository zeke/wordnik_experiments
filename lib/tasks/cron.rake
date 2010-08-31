%w(rubygems hpricot nokogiri open-uri).each {|lib| require lib}

desc "Cron task for heroku; Imports recent stuff from wordnik and a chunk of any missing wordstats"
task :cron => :environment do
  Rake::Task["import:wordnik_recent"].invoke
  Rake::Task["scrape:missing_wordstats"].invoke
end