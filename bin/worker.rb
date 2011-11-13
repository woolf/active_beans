#!/usr/bin/env ruby -wKU

require "rubygems"
require "json"
require File.join(File.dirname(__FILE__), "../lib/active_beans")
require File.join(File.dirname(__FILE__), "../lib/active_beans/queue/beanstalk")

beanstalk = Beanstalk::Pool.new(['localhost:11300'])

beanstalk.watch("requests")

loop do
  job = beanstalk.reserve
  job.delete
  body = JSON.load(job.body)
  puts "Recieved JobID #{job.id}"
  p job.server
  p body

  response = Beanstalk::Connection.new(job.server)
  response.use("responses#{job.id}")
  puts "Sending response back to #{job.server}"
  p response.put((body << "response").to_json)
  response.close

  job.delete
end



