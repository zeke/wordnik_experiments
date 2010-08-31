%w(rubygems hpricot nokogiri open-uri).each {|lib| require lib}

desc "Cron task for heroku; Imports missing wordstats"
task :cron => :environment do
  Rake::Task["import:wordnik_lookups"].invoke
  Rake::Task["import:wordnik_favorites"].invoke
  Rake::Task["scrape:missing_wordstats"].invoke
end