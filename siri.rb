#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'zlib'
require 'cfpropertylist'
require 'pp'

class String
  def remove_leading_hex(hex_string)
    length = hex_string.length/2
    return self[length..-1] if self[0...length].unpack('H*').first == hex_string
    self
  end
end

module SiriServer
  include EventMachine::Protocols::LineText2
  def ssl_handshake_completed
    puts "[firebolt55439] SSL Is Up!"
    @zstream = Zlib::Inflate.new
    @stream = ""
  end

  def post_init
    start_tls(:cert_chain_file => "./server.passless.crt",
              :private_key_file => "./server.passless.key",
              :verify_peer => false)
  end

  def receive_binary_data(data)
    data = data.remove_leading_hex('0d0a') 
    data = data.remove_leading_hex('aaccee02') 
    @stream << @zstream.inflate(data)
    parse
  end

  def unbind
    #@zstream.finish
    @zstream.close
  end

  def receive_line(line)
    puts line
    set_binary_mode if line.match(/X-Ace-Host/)
  end

  def parse
    puts "[firebolt55439] This Program Is Successful! Keys Will Now Be Displayed!!!! "
    if @stream[0...5].unpack('H*').first.match(/030000..../) 
      puts "-----------------------------------------------------------------"
      puts "* PING ? : #{@stream[0...5].unpack('H*').first.match(/030000(....)/)[1].to_i(16)}"
      @stream = @stream[5..-1]
    end

    chunk_size = @stream[0...5].unpack('H*').first.match(/0200(......)/)[1].to_i(16) rescue 1000000
    if (chunk_size < @stream.length+5)
      plist_data = @stream[5...5+chunk_size]
      plist = CFPropertyList::List.new(:data => plist_data)
      puts "-----------------------------------------------------------------"
      plist_object = CFPropertyList.native_types(plist.value)
      pp plist_object
      (plist_object["properties"]["packets"] || []).each do |packet|
        puts packet.length
        File.open("data.firebolt55439.speexpacket.spx", "a"){|f| f.write(packet)}
      end
      @stream = @stream[chunk_size+5..-1]
    end
  end
end

puts "Made By Applidium And Edited By firebolt55439 On Github. http://github.com/firebolt55439"
puts "EventMachine Successfully Started!"
EventMachine.run do
  EventMachine::start_server '0.0.0.0', 443, SiriServer
end
