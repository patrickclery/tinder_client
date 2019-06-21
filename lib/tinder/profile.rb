# frozen_string_literal: true

module Tinder::Profile

  # @returns Hash
  def profile
    data = { include: "account,boost,email_settings,instagram," \
                      "likes,notifications,plus_control,products," \
                      "purchase,spotify,super_likes,tinder_u,"\
                      "travel,tutorials,user" }
    get endpoint(:profile), **data
  end

end
