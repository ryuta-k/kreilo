# Install hook code here
def copy(file_name, from_dir, to_dir)
  from_dir = File.join(File.dirname(__FILE__), from_dir)
  from = File.expand_path(File.join(from_dir,file_name))

  to_dir =  File.join(RAILS_ROOT, to_dir)
  FileUtils.mkdir to_dir unless File.exist?(File.expand_path(to_dir))
  to = File.expand_path(File.join(to_dir, file_name))

  FileUtils.cp from, to, :verbose => true unless File.exist?(to)
end

def copy_image(file_name)
  copy file_name, 'images', 'public/images/kreilo'
end

def copy_javascript(file_name)
  copy file_name, 'javascripts', 'public/javascripts/kreilo' 
end

def copy_css(file_name)
  copy filename, 'css', 'public/stylesheets/kreilo'
end


desc "Copies the widgets assets (images and javascripts) to the public folder"
namespace :kreilo do
  task :setup do
    copy_javascript 'timer.js'
  end
end

