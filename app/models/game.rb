# == Schema Information
#
# Table name: games
#
#  id              :integer         not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string(255)
#  timeout         :integer
#  player_num      :integer
#  player_wait_new :integer
#

class Game < ActiveRecord::Base
validates_presence_of :name
validates_uniqueness_of :name
validates_numericality_of :timeout, :player_num


end
