#!/usr/bin/env ruby

require 'bundler/setup'
require 'rake'
require "tinder"

namespace :tinder do
  desc 'Fetch a token to access the Tinder API'
  task :fetch_token do
    # Check that a phone number was given. If it's not, it's a good reason to fail
    # here because most likely the whole ENV is empty
    fail 'No phone number specified' if ENV['phone_number'].nil?
    phone_number = ENV['phone_number'].to_s

    ## Request a confirmation code
    Tinder::Client.request_code(phone_number)

    puts ("Enter the confirmation code sent to #{phone_number}> ")
    confirmation_code = STDIN.gets.chomp.to_s

    puts "Validating..."
    access_token = Tinder::Client.validate(phone_number, confirmation_code)
    puts "Done!\n"
    puts "Your tinder access token is #{access_token}\n"
  end
end
