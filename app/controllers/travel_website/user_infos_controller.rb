module TravelWebsite
class UserInfosController < ApplicationController
  def show
  end
  def update
    @user_info = UserInfo.find(params[:id])
    @user_info.update_attributes(params[:user_info])
    respond_with_bip(@user_info)
  end
end
end
