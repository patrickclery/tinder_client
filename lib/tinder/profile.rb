# frozen_string_literal: true

module Tinder::Profile

  # @returns Hash
  def profile
    get 'profile'
  end

end
