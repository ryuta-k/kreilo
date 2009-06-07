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

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
