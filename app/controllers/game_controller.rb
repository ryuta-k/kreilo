class GameController < ApplicationController
before_filter :set_titles

def prestart

end

def wait



end

def button

  if (params[:button] == 'pos') 
#    Data.find()
#    render :layout => false 
#    Data.rand
  end


   render :text => "heeeeellooooo", :layout => false 
end

def finish
render

end

def set_titles
  @game = Game.find(params[:id]) 
  @page_title = @game.name
  @header_header = @game.name
  @header_subheader = "just testing"
end

end
