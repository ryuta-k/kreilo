
module HomeHelper

def kreilo_tabs (name, data)
  render_tabnav name, :generate_css => true do
  add_tab do |t|
    t.named 'Home'
    t.titled 'Home Page'
    t.links_to :controller => 'home'
  end
  i = 0
  data.each do |game|
    i += 1
    add_tab do |t|
      t.named game.name
      t.titled game.name
      t.links_to :controller => 'game', :action => 'prestart', :id => game.id
    end
  end
  end
end

end
