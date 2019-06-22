# frozen_string_literal: true

module Tinder::Profile

  attr_accessor :active_user

  # @returns Hash
  def profile
    data = { include: "account,boost,email_settings,instagram," \
                      "likes,notifications,plus_control,products," \
                      "purchase,spotify,super_likes,tinder_u,"\
                      "travel,tutorials,user" }

    @active_user = begin
      response = get(endpoint(:profile), **data)
      response.dig('data') || fail(UnexpectedResponse(response))
    end
  end

end
