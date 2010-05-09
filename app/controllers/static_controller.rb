class StaticController < ApplicationController
  
  def index
    wordnik = Wordnik.new(WORDNIK_API_KEY)
    @words = params[:q].present? ? params[:q].split(",") : %w(dog cat monkey)
    @responses = {}
    @words.each do |word|
      @responses[word] = wordnik.frequency(word)
    end
  end
  
  def related
    wordnik = Wordnik.new(WORDNIK_API_KEY)
    if params[:q].present?
      url = "http://api.wordnik.com/api/word.json/#{params[:q]}/related?api_key=#{WORDNIK_API_KEY}&type=synonym"
      @related = HTTParty.get(url)
    end
  end
  
protected
  
end
