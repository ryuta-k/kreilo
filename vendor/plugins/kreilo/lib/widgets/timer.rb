module Kreilo 
  module Timer

    def kreilo_timer (timeout, onFinish, id)
      html = "<div id='timer'>#{timeout}</div>"
      html += periodically_call_remote(:url => { :action => onFinish, :id => id}, :frequency => timeout) 
      add_js_header( 'kreilo/timer.js') 
      add_css_header('kreilo/timer.css')
      html += js_at_load("timer()")
      html
    end

    def kreilo_data
#      data = Data.rand
#      html = "<div id='data' >#{data}</div>"
      html = "<div id='data' >testetee</div>"
    end

    def kreilo_button (id) 
#TODO: data should be a parameter
     html = "<div id='#{id}' ></div>"
     html += javascript_tag "
       $$('#" + id +"').each(function(button){
        button.observe('click', function(){
          new Ajax.Updater('data', '/#{@controller_name}/button/#{@game.id}' ,{
                                 method: 'get',
                                 parameters: { button: '#{id}', 
                                               datas: '#{@data}'           
                                                        }
                                   });
         });

       });
      "
      #html += js_at_load("test()")
      html     

    end



  end
end
