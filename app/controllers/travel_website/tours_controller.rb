module TravelWebsite
class ToursController < ApplicationController

  def index
     @tours = Tour.where('status=1').order('days')
  end

  def show
    if (params[:id] == 'bus')
      @tours = Tour.bus_tours.order('days')
      render :index
      return
    end
    if (params[:id] == 'package')
      @tours = Tour.packages.order('days')
      render :index
      return
    end
    if (params[:id] == 'cruise')
      @tours = Tour.cruises.order('days')
      render :index
      return
    end
    @tour = Tour.find(params[:id])
    @datelist = []
    rsv_date = @tour.tour_setting.days_in_advance
    rsv_date = cfg.get_config('max_reservation_days').to_i if rsv_date == 0
    @max_date = Date.today + rsv_date
    if @tour.schedules.count > 0
      @datelist = @tour.schedules.map {|s| s.departure_date.strftime('%Y.%m.%d')}.join(',')
      @max_date = (@tour.schedules.last.departure_date.to_date - Date.today).to_i
    end
  end

  def order
    if params[:departure_date].blank?
      flash[:error] = 'Schedule not found. Please click a departure date'
    else
      @tour = Tour.find(params[:id])
      @order = Order.new
      @schedule = @tour.schedules.where('DATE(departure_date)=?', parse_date(params[:departure_date])).first
    end
  end
  def parse_date(date_str)
    r = date_str.split('/')
    Date.new(r[2].to_i, r[0].to_i, r[1].to_i)
  end
  def xxx
    tour = Tour.find(params[:id])
    order = Order.new
    order.status = 0
    order.order_method = 'website'
    order.schedule = 0
    order.order_source = tour
    order.order_method = 'Website'
    order.state = 'draft'
    params[:num_adult].each_with_index do | n, idx |
      item = order.order_items.build(:num_adult => n, :num_child => params[:num_child][idx])
      item.num_total = item.num_adult + item.num_child
      item.amount = tour.tour_price["price#{item.num_total}"] if tour.tour_price
    end
    c = order.build_order_customer
    c.customer = current_user
    c.full_name = current_user.user_info.full_name if current_user.user_info

    p = order.build_order_price
    p.num_rooms = order.order_items.count
    p.num_adult = order.order_items.sum(:num_adult)
    p.num_child = order.order_items.sum(:num_child)
    p.num_total = order.order_items.sum(:num_total)
    p.balance_amount = p.total_amount = order.order_items.sum(:amount)

    order.save
    render :text => 'order!'
  end

end
end
