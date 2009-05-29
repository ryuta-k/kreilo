# Kreilo - Human computation gaming framework
# Copyright (C) 2009 Jordi Polo Carres
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'Qt'

module Kreilo
  #save typing 

  class KObject < Qt::Object
    def initialize (parent = nil)
      super parent
    end
    def konnect (src, signal, dst, slot)
      Qt::Object.connect(src, SIGNAL(signal), dst, SLOT(slot))
    end
    def konnect_signal (src, signal, dst, slot)
      Qt::Object.connect(src, SIGNAL(signal), dst, SIGNAL(slot))
    end

  end

end
