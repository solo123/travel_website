module TravelWebsite
class OrdersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @tour = Tour.find(params[:tour_id])
    @order = Order.new
    @datelist = []
    @max_date = Date.today + 30
    @addresses = UserInfo.find_by_user_id(current_user.id).addresses
    if @tour.schedules.count > 0
      @datelist = @tour.schedules.map {|s| s.departure_date.strftime('%Y.%m.%d')}.join(',')
      @max_date = (@tour.schedules.last.departure_date.to_date - Date.today).to_i
    end    
  end
  def create
    @order = Order.new
    @order.schedule_id = params[:schedule_id]
    @order.order_method = 'website'
    @order.status = 0
    unless @order.save
      flash[:error] = @order.errors.full_messages.to_sentence
    else
      params[:num_adult].each do |pax|
        item = @order.order_items.build
        item.num_adult = item.num_total = pax.to_i
        item.num_child = 0
        item.save
      end
      ui = current_user.user_info
      detail = @order.build_order_detail
      detail.user_info_id = ui.id
      detail.full_name = ui.full_name
      detail.telephone = ui.telephones.first.tel if ui.telephones.first
      detail.email = ui.emails.first.email_address if ui.emails.first
      detail.bill_address = ui.addresses.first.to_s if ui.addresses.first
      detail.save
      biz = Biz::OrderPayment.new
      biz.caculate_price(@order)
      redirect_to @order
    end
  end

  def show
    @object = Order.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @object.order_detail.user_info_id == current_user.user_info.id
  end
  def payment
    @object = PayCreditCard.new
    @object.full_name = current_user.user_info.full_name
    order = Order.find(params[:id])
    @object.amount = order.order_price.actual_amount
    @credit_card_rate = InputType.where(:type_name => 'credit.card.rate').collect{|ipt| [ipt.type_text, ipt.type_value]}.join('|') + '|'
  end
end
end
