class HomeController < ApplicationController
  
  def index
    ## caching trending gif response. It will increase application performance.
    Rails.cache.delete('@trending') if @trending.nil?
    Rails.cache.fetch('@trending',{expires_in: 1.hours}) do
      ##HTTParty is a gem, which is used to communicate with API
      response = HTTParty.get("http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=9")
      ## I am collecting only the images,as we are going to show only GIF's
      @trending = response.parsed_response["data"].collect{|gif| gif["images"]["fixed_height"]["url"]}
    end
    
  end

  def search
    ## i am converting the string, which entered in the UI.
    search = params["value"].split(" ").join("+")
    search_response = HTTParty.get("http://api.giphy.com/v1/gifs/search?q=#{search}&api_key=dc6zaTOxFJmzC&limit=9")
    @search_results=search_response.parsed_response["data"].collect{|gif| gif["images"]["fixed_height"]["url"]}
    render :layout=>false
  end

end
