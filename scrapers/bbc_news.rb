require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'calais_helper'

include CalaisHelper

address = ARGV[0]

doc = Hpricot( open( address ) )  # For URLs
#doc = open(address) { |f| Hpricot(f) }  # For local files

description_node = doc.search("//meta[@name='Description']")
description = description_node.inner_text

puts "DESCRIPTION: #{description}"

storybody = doc.search("//td[@class='storybody']")

text = storybody.inner_text.split('The BBC may edit your comments and not all emails will')[0]

tags = get_tags(text)

for tag_key in tags.keys
  puts '--'
  puts tag_key
  for tagged_result in tags[tag_key]
    puts "\t#{tagged_result}"
  end
end