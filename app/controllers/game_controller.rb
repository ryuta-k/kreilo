class GameController < ApplicationController
before_filter :set_titles

def prestart

end

def wait



end

def button

#  if (params[:button] == 'pos') 
    d = Datas.find_by_data(params[:datas])
    if not d.nil?
      d.add (params[:button])
    end
#    Data.find()
#    render :layout => false 
#    Data.rand
#  end

  
   @data = Datas.random
   render :text => @data , :layout => false 
end

def finish
render

end

def set_titles
  @game = Game.find(params[:id]) 
  @page_title = @game.name
  @header_header = @game.name
  @header_subheader = "just testing"
  @controller_name = "game"
end

end
