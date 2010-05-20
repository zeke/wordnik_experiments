class WordsController < ApplicationController

  def index
    order_by = params[:order_by].present? ? "#{params[:order_by]}_count" : "lookup_count"
    @words = Word.find(:all, :limit => 800, :order => ["#{order_by} DESC"])

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
