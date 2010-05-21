class WordsController < ApplicationController

  def index
    params[:order_by] ||= "lookup_count"
    params[:direction] ||= "desc"

    pagination_params = {:page => params[:page], :order => "#{params[:order_by]} #{params[:direction]}", :per_page => 250}

    if params[:q]
      q = params[:q].dup
      if q.starts_with?("*")
        q.gsub!("*", "")
        @words = Word.spelling_ends_with(q).having_wordstats.paginate(pagination_params)
        
      elsif q.ends_with?("*")
        q.gsub!("*", "")
        @words = Word.spelling_begins_with(q).having_wordstats.paginate(pagination_params)
        
      elsif q.starts_with?("list:")
        begin
          q.gsub!("list:", "")
          url = "http://www.wordnik.com/lists/#{q}.xml"
          response = HTTParty.get(url)
          @list_title = response['rss']['channel']['title'].sub("Wordnik.com: ", "")
          list = response['rss']['channel']['item'].map{ |item| item['title'] }
          # raise list.inspect
          @words = Word.in_list(list).having_wordstats.paginate(pagination_params)
        rescue
          @words = []
          @list_title = q
          # flash[:error] = "Sorry, the #{q} list could not be found."
        end
      else
        @words = Word.spelling_like(q).having_wordstats.paginate(pagination_params)
      end
      
    else
      @words = Word.having_wordstats.paginate(pagination_params)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @words }
    end
  end

  # def show
  #   @word = Word.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @word }
  #   end
  # end
  # 
  # def new
  #   @word = Word.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @word }
  #   end
  # end
  # 
  # def edit
  #   @word = Word.find(params[:id])
  # end
  # 
  # def create
  #   @word = Word.new(params[:word])
  # 
  #   respond_to do |format|
  #     if @word.save
  #       flash[:notice] = 'Word was successfully created.'
  #       format.html { redirect_to(@word) }
  #       format.xml  { render :xml => @word, :status => :created, :location => @word }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @word.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # def update
  #   @word = Word.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @word.update_attributes(params[:word])
  #       flash[:notice] = 'Word was successfully updated.'
  #       format.html { redirect_to(@word) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @word.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # def destroy
  #   @word = Word.find(params[:id])
  #   @word.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(words_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
end
