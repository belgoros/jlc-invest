class AdminsController < ApplicationController
  def new
  end
  
  def show
    @user = Admin.find(params[:id])
  end
end
