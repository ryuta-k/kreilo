# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

# This should be generally availablefor everyone
Dir["#{RAILS_ROOT}/lib/kreilo/*.rb"].each do |file|
  require_dependency file
end

#site is created only once, can be accessed globally
$site ||= Kreilo::Site.new


end
