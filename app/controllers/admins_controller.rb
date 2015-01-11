class AdminsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @admins = Admin.paginate(page: params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      sign_in @admin
      redirect_to :root, notice: t(:created_success, model: Admin.model_name.human)
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
    if @admin.update_attributes(admin_params)
      sign_in @admin
      redirect_to :root, notice: t(:updated_success, model: Admin.model_name.human)
    else
      render 'edit'
    end
  end

  def destroy
    Admin.find(params[:id]).destroy
    redirect_to admins_url, notice: t(:destroyed_success, model: Admin.model_name.human)
  end

  private

    def correct_user
      @admin = Admin.find(params[:id])
      redirect_to(root_path) unless current_user?(@admin)
    end

    def admin_params
      params.require(:admin).permit(:email, :firstname, :lastname, :password, :password_confirmation)
    end
end
