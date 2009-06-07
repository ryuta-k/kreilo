require 'share_this'
module KreiloShare
  def kreilo_share(options = {})
    to_render = <<-HANDLE
       <div class="kreilo_share" >
    HANDLE
    to_render+= share_this(options)
    to_render+="</div>"
  end
end
