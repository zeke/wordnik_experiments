class StaticController < ApplicationController
  
  before_filter :find_recent_queries, :only => [:index, :recent_queries]
  
  def index
  end
  
  def recent_queries
    out = @recent_queries.map do |query|
      {
        :id => query.id,
        :q => query.q,
        :result_count => query.result_count
      }
    end
    respond_to do |format|
      format.json  { render :json => out.to_json }
    end
  end
  
  # Played around with this in the beginning.. may not work any more..
  def frequency
    wordnik = Wordnik.new(WORDNIK_API_KEY)
    @words = params[:q].present? ? params[:q].split(",") : %w(dog cat monkey)
    @responses = {}
    @words.each do |word|
      @responses[word] = wordnik.frequency(word)
    end
  end
  
  # Played around with this in the beginning.. may not work any more..
  def related
    wordnik = Wordnik.new(WORDNIK_API_KEY)
    if params[:q].present?
      url = "http://api.wordnik.com/api/word.json/#{params[:q]}/related?api_key=#{WORDNIK_API_KEY}&type=synonym"
      @related = HTTParty.get(url)
    end
  end
  
protected
  
  def find_recent_queries
    last_100_queries = Query.result_count_greater_than(1).find(:all, :limit => 100, :order => ['created_at DESC'])
    # Filter out dupes.. stop at fifty.
    @recent_queries = []
    query_strings = []
    last_100_queries.each do |query|
      next if query_strings.include? query.q
      @recent_queries << query
      query_strings << query.q
      break if @recent_queries.size >= 50
    end
  end

end
