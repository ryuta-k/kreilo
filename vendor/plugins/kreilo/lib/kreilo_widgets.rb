#can this class with something?
module Kreilo
 module Core
   def add_css_header(header)
     content_for :header_css do 
       stylesheet_link_tag(header)
     end 
   end
   def add_js_header (header)
     content_for :header_js do 
       javascript_include_tag(header)  
     end 
   end
   def js_at_load (js_code)
     javascript_tag "Event.observe( window, 'load', function() { #{js_code}  } ); "
   end

 end
end

ActionController::Base.helper Kreilo::Core

require 'widgets/timer.rb'
ActionController::Base.helper Kreilo::Timer

