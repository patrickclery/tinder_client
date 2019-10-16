#!/usr/bin/env ruby

require 'bundler/setup'
require 'rake'
require "tinder"

# ### Environment Variables
# `phone_number` - the phone number to login with
# `tinder_token_path` - where to store access_token.txt

def fetch_token(phone_number)
  client = Tinder::Client

  # Request a code
  client.request_code(phone_number)
  puts ("Enter the confirmation code sent to #{phone_number}> ")
  confirmation_code = STDIN.gets.chomp.to_s

  # Validate the code and get our 2nd auth factor (refresh token)
  puts "Validating..."
  refresh_token = client.validate(phone_number, confirmation_code)
  puts "Done!\n"
  puts "Your refresh token is #{refresh_token}\n"

  # Login using the 2nd key
  puts "Logging in..."
  api_token = client.login(phone_number, refresh_token)
  puts "Done!\n"
  puts "Your tinder API token is #{api_token}\n"
  api_token
end

def token_path
  "#{ENV['tinder_token_path'] || '.'}/tinder_access_token.txt"
end

namespace :tinder do

  desc 'Fetch an API token from Tinder'
  task :fetch_token do
    fetch_token(ENV['phone_number'].to_s)
  end

  desc 'Save an API token to $token_path'
  task :save_token do
    access_token = fetch_token(ENV['phone_number'].to_s)
    File.open(token_path, 'w') { |f| f.puts(access_token) }
    puts "Saved to #{token_path}\n"
  end

  desc 'Fetch my profile'
  task :profile do
    client           = Tinder::Client.new
    client.api_token = IO.read(token_path).chomp
    profile          = client.profile
    puts profile
  end

  desc 'Fetch recommendations'
  task :recommendations do
    client           = Tinder::Client.new
    client.api_token = IO.read(token_path).chomp

    feed = client.get_recommended_users(:recommendations)
    feed.each do |person|
      puts person
    end
  end

  desc 'Fetch updates'
  task :get_updates do
    client           = Tinder::Client.new
    client.api_token = IO.read(token_path).chomp

    updates = client.get_updates
    updates.matches.each do |match|
      puts match
    end
  end

end
