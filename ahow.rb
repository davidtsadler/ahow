=begin
    A small Ruby script to download the podcasts of 'A History of the World in 100 Objects'.
    Copyright (C) 2010 David T. Sadler

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end
 
require 'rss/2.0'
require 'open-uri'

def delete_all_tags(file)
  id3v2(["--delete-all"], file)
end

def id3v2(params, file)
  system(%Q!id3v2 #{params.join(' ')} "#{file}"!)
end

source = "http://downloads.bbc.co.uk/podcasts/radio4/ahow/rss.xml"
content = ""
open(source) do |s| content = s.read end
rss = RSS::Parser.parse(content, false)
rss.items.each do |item|
	system("wget #{item.link}")

	filename = item.link.gsub("http://downloads.bbc.co.uk/podcasts/radio4/ahow/","")

  id3v2_params = []
  id3v2_params << %Q!--song "#{item.title}"!
  id3v2_params << %Q!--artist "Neil MacGregor"!
  id3v2_params << %Q!--album "A History of the World in 100 Objects"! 
  id3v2_params << %Q!--year "2010"!
  id3v2_params << %Q!--genre "101"!

	delete_all_tags(filename)
	id3v2(id3v2_params, filename)
end
