module TravelWebsite
class SimpleResourcesController < ApplicationController
  def new
    @object = object_name.classify.constantize.new
  end
  def update
    load_object
    @object.update_attributes(params[object_name.singularize.parameterize('_')])
    respond_with_bip @object
  end
  def destroy
    load_object
    @object.destroy
  end
  def create
    @object = object_name.classify.constantize.new(params[object_name.singularize.parameterize('_')])
    if @object.is_a? Telephone
      @object.tel_number = current_user.user_info
    elsif @object.is_a? Email
      @object.email_data = current_user.user_info
    elsif @object.is_a? Address
      @object.address_data = current_user.user_info
    end
    @object.save
  end
    def destroy
      load_object
      @object.destroy
    end

  protected
  def load_object
    @object = object_name.classify.constantize.find(params[:id])
  end
  def object_name
    controller_name #.singularize
  end
end
end
