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

  end
end
