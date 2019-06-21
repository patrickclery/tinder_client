#!/usr/bin/env ruby

require 'bundler/setup'
require 'rake'
require "tinder"

# ### Environment Variables
# `phone_number` - the phone number to login with
# `tinder_token_path` - where to store access_token.txt

def fetch_token(phone_number)
  ## Request a confirmation code
  Tinder::Client.request_code(phone_number)

  puts ("Enter the confirmation code sent to #{phone_number}> ")
  confirmation_code = STDIN.gets.chomp.to_s

  puts "Validating..."
  access_token = Tinder::Client.validate(phone_number, confirmation_code)
  puts "Done! Your tinder access token is #{access_token}\n"
  access_token
end

def token_path
  "#{ENV['tinder_token_path'] || '.'}/tinder_access_token.txt"
end

namespace :tinder do
  desc 'Fetch an access token to access the Tinder API'
  task :fetch_token do
    fetch_token(ENV['phone_number'].to_s)
  end

  desc 'Save an access token locally for the client to read'
  task :save_token do
    access_token = fetch_token(ENV['phone_number'].to_s)
    File.open(token_path, 'w') {|f| f.puts(access_token)}
  end

end
