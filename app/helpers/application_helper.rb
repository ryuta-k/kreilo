# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
# This should be generally availablefor everyone
#require_dependency "#{RAILS_ROOT}/lib/kreilo/base.rb"
#require_dependency "#{RAILS_ROOT}/lib/kreilo/globals.rb"

#Dir["#{RAILS_ROOT}/lib/kreilo/*.rb"].each do |file|
#  require_dependency file
#end
#ActiveRecord::Base.logger = Logger.new(STDOUT) 
=begin
#site is created only once, can be accessed globally
$site ||= Kreilo::Site.new
=end

end
