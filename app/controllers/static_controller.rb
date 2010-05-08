class StaticController < ApplicationController
  
  def index
    @words = params[:q].present? ? params[:q].split(",") : %w(dog cat monkey)
    @responses = {}
    @words.each do |word|
      url = "http://api.wordnik.com/api/word.json/#{word}/frequency?api_key=b39ee8d5f05d0f566a0080b4c310ceddf5dc5f7606a616f53"
      @responses[word] = HTTParty.get(url)
    end
  end
  
protected
  
end
