module TravelWebsite
  class MyaccountsController < ApplicationController
    before_filter :authenticate_user!
    def show
      u = current_user
      unless u.user_info
        ui = u.build_user_info
        ui.full_name = u.email.split('@').first
        em = ui.emails.build
        em.email_address = u.email
        ui.save
      end
      @user_info = current_user.user_info
    end
    def update
      @user_info = current_user.user_info
      respond_with_bip @user_info
    end
  end
end

