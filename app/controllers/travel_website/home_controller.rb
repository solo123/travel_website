module TravelWebsite
class HomeController < ApplicationController
	def index
	end
  def get_signin_status
  end
  def zh
    if session[:current_local]
      session.delete :current_local
    else
      session[:current_local] = 'zh'
    end
    redirect_to :action => :index
  end

end
end
