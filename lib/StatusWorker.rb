require 'rubygems'
require 'resque'
require 'uri'
require 'net/http'

class StatusWorker
  @queue = :compute

  def self.perform(url)
    puts "Work started for #{url}"
    sleep 5
    # puts "#{a} #{operation} #{b} = #{a.send(operation, b)}"
  end
end
