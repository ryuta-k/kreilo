#can this class with something?
module Kreilo
module Core
def add_css_header(header)
  add_to_header(':header_css', header)
end

def add_js_header (header)
  add_to_header(':header_js', header)
end

def add_to_header(header_name, header_location)
  "<%contents_for #{header_name} do %> <%= javascript_include_tag('#{header}') %> <% end %>"
end

end
end

ActionController::Base.helper Kreilo::Core

require 'widgets/kreilo_timer.rb'
ActionController::Base.helper Kreilo::Timer

