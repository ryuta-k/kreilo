class Label < ActiveRecord::Base
  belongs_to :dataItem
=begin
  def initialize (new_label)
    previous = Labels.find_by_label(new_label)
    if previous.nil?
      label = new_label
      count = 1
    else
      previous.count += 1
      return previous
    end

  end
=end

end
