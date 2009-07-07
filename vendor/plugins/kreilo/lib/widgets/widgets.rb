module Kreilo 
  module Widgets

#TIMER 
#bar is the placeholder of the progressBar
#timer indicates the amount of time for timer
    def kreilo_timer (timeout, onFinish)
      add_js_header( 'kreilo/timer2.js')
      add_js_header( 'ProgressBar.js')  
      add_css_header('kreilo/timer.css')
      #html += periodically_call_remote(:url => { :action => onFinish, :id => id}, :frequency => timeout) 
      timer_id = "timer" + timeout.to_s 
      bar_id = "bar" + timeout.to_s  # trying to have unique id

      html = "<div id='#{bar_id}'></div>"
      html += "<div class='timer' id ='#{timer_id}' >#{timeout}</div>"
      html += js_at_load("timer('#{timer_id}', '#{bar_id}', '#{onFinish}')")
      html
    end

#DATA display widget
    def kreilo_data (data_id) 
#      data = Data.rand
#      html = "<div id='data' >#{data}</div>"
      html = "<div id='#{data_id}' >TESTING</div>"
      add_css_header('kreilo/data.css')
    end

    # a button  with id button_id that acts over
    # data contained in the element with id data_id
    #  '/#{@controller_name}/button/#{@game.id}' 
    def kreilo_data_updater (button_id, data_id) 
#TODO: clean game.id from there 
     html = "<div id='#{button_id}' class='button' ></div>"
     add_css_header('kreilo/buttons.css')
     html += javascript_tag "
       $$('#" + button_id +"').each(function(button){
        button.observe('click', function(){
          new Ajax.Updater('#{data_id}', '/data/update' ,{
                                 method: 'put',
                                 parameters: { button: '#{button_id}', 
                                               datas: document.getElementById('#{data_id}').childNodes[0].nodeValue           
                                             }
                                   });
         });

       });
      "
      #html += js_at_load("test()")
      html     
    end


 def kreilo_game_links 
   html = ""
   Game.find(:all).each do |g|
     html += kreilo_game_link (g.name)
     html += "\n"
   end
   html
 end 

 def kreilo_game_link (game_name, link_name = nil)
  game = Game.find_by_name(game_name)   
  lname= link_name || game_name
  html = "<div class='button' id='#{game_name}'><a href='/game/new/#{game.id}'> #{lname}</a></div>"
 end


 
# here too much information site dependent here.
#TABS for the games, a better solution must be found
#<!-- <% kreilo_tabs :games, Game.find(:all) %> -->
    def kreilo_tabs (name, data)
      add_css_header('kreilo/tab.css')
      render_tabnav name, :generate_css => true do
        add_tab do |t|
          t.named 'Home'
          t.titled 'Home Page'
          t.links_to :controller => 'home'
        end
        i = 0
        data.each do |game|
          i += 1
          add_tab do |t|
            t.named game.name
            t.titled game.name
            t.links_to :controller => 'game', :action => 'new', :id => game.id
          end
        end
      end
    end



  end
end
