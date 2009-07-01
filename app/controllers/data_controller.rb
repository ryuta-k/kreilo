class DataController < ApplicationController

#TODO: this will be exported as configurable by the user
Labels = [{:name=> "negative", :activated_by => "neg"}, {:name=> "positive", :activated_by => "pos"} ] 


def update
#  if (params[:button] == 'pos')
    d = DataItem.find_by_data(params[:datas])
    if not d.nil?
      Labels.each do |l|
        if params[:button] == l.activated_by 
          d.labels << Label.new(l.name)
          d.save
        end
      end
    end

   @data = DataItem.random
   render :text => @data , :layout => false
end

end
