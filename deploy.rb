require 'rubygems'
require 'net/ssh'
require 'net/scp'

def task(name)
  puts "#{'#' * 3} #{name} started #{'#' * 3}"
  yield
  puts "#{'#' * 3} #{name} finished #{'#' * 3}"
end

def deploy
  host = "192.168.154.135"
  user = "darth"
  task('create tar') { puts `make tar` }
  Thread.pass
  Net::SCP.start(host, user) do |scp|
    task('upload') { scp.upload! 'dist.tar.gz', '~/' }
  end
  Thread.pass
  Net::SSH.start(host, user) do |ssh|
    task('untar') { puts ssh.exec!('tar xvzf dist.tar.gz') }
    #task('build') { puts ssh.exec!('make') }
    task('run') { puts ssh.exec!('make test') }
  end
  Thread.pass
end

def do_deploy
  $deploy.kill if $deploy
  $deploy = Thread.new { deploy }
end

reading = Thread.new do
  while line = gets.chomp!
    case line
      when "q" then
        puts "exiting"
        exit
      when "r" then
        do_deploy
    end
  end
  $deploy.join
  
end

reading.join
