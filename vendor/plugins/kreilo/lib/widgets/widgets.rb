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

# WAIT
    def kreilo_wait 
      game = Game.find (params[:id])
      add_js_header( 'kreilo/waitPlayers.js')
      add_js_header( 'dialog.js')
      add_js_header( 'ProgressBar.js')  

      check_url = "/pregame/"+ game.id.to_s+ "/waiting_player" 
      destiny_url = "after.html" 

      html = "<div id='container'>container</div>"
      html += "<button onclick='javascript:;' id='waitPlayers'>waitPlayers</button>"
      
        html += "
<script text='text/javascript'>
Dialogs.load();
         new Dialog({
            handle:'#waitPlayers',
                title:'waiting...',
                content: '',
                afterOpen:function(){waitPlayers('#{check_url}', #{game.id});},
                afterClose:function(){},
                width:300,
                height:60,
                });
</script>
 "
       html
    end


#DATA display widget
    def kreilo_data (data_id) 
#      data = Data.rand
#      html = "<div id='data' >#{data}</div>"
      html = "<div id='#{data_id}' >TESTING</div>"
      add_css_header('kreilo/data.css')
    end

#DATA UPDATER
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


#GAME LINKS
#parameter, the controller that will get the action
 def kreilo_game_links 
   html = ""
   controller = :pregame
   Game.find(:all).each do |g|
     html += kreilo_game_link ( controller,g )
     html += "\n"
   end
   html
 end 

 def kreilo_game_link ( controller, game,link_name = nil)
  lname= link_name || game.name
  html = "<div class='button' id='#{game.name}'><a href='/#{controller.to_s}/new/#{game.id}'> #{lname}</a></div>"
 end

 def kreilo_play_link (game, name=nil)
 lname = name || "play" 
 html =  "<div class ='button'> <a href='/pregame/show/#{game.id}'}>#{lname}</a> </div>"
 
 end
 

  end
end
