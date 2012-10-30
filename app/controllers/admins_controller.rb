class AdminsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]

  def index
    @admins = Admin.paginate(page: params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      sign_in @admin
      flash[:success] = t(:created_success, model: Admin.model_name.human)
      redirect_to @admin
    else
      render "new"
    end
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def edit
  end

  def update
    if @admin.update_attributes(params[:admin])
      flash[:success] = t(:updated_success, model: Admin.model_name.human)
      sign_in @admin
      redirect_to @admin
    else
      render 'edit'
    end
  end

  def destroy
    Admin.find(params[:id]).destroy
    flash[:success] = t(:destroyed_success, model: Admin.model_name.human)
    redirect_to admins_url
  end

  private

  def correct_user
    @admin = Admin.find(params[:id])
    redirect_to(root_path) unless current_user?(@admin)
  end

end
