%w(rubygems hpricot).each {|lib| require lib}


desc "Cron task for heroku; Imports missing wordstats"
task :cron => :environment do
  Rake::Task["scrape:missing_wordstats"].invoke
end