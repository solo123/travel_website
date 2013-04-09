module TravelWebsite
class HomeController < ApplicationController
	def index
	end
  def set_language_en
    locale = :en
    render :text => 'en'
  end
  def set_language_zh
    locale = :zh
    render :text => 'zh'
  end

end
end
