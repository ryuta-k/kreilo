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



class Enumeration
  def Enumeration.add(key,value)
    @hash ||= {}
    @hash[key]=value
  end

  def Enumeration.const_missing(key)
    @hash[key]
  end   

  def Enumeration.each
    @hash.each {|key,value| yield(key,value)}
  end

  def Enumeration.values
    @hash.values || []
  end

  def Enumeration.keys
    @hash.keys || []
  end

#  def Enumeration.[](key)
#    @hash[key]
#  end
end

