module TravelWebsite
class PayCreditCardsController < ApplicationController
  def create
    cc = PayCreditCard.new(params[:pay_credit_card])
    order = Order.find(params[:order_id])
    if order.status > 2
      flash[:error] = 'Cannot pay this order.'
    else
      cc.order = order
      cc.user_info = current_user.user_info
      if cc.save
        if order.status == 0
          order.status = 1
          order.save
        end
      else
        flash[:error] = 'Save credit card info error:' + cc.errors.all_messages.to_sentence
      end
      redirect_to order
    end
  end
  def show
    @object = PayCreditCard.find(params[:id])
  end
  def destroy
    @object = PayCreditCard.find(params[:id])
    if @object.status == 0
      @object.status = 7
      @object.save
      order = @object.order
      if order && order.status == 1
        order.status = 0
        order.save
      end
    else
      flash[:error] = 'Cannot cancel this credit card payment.'
    end
    redirect_to @object.order
  end
end
end
