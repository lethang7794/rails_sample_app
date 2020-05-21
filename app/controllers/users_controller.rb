class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update]
  before_action :correct_user,    only: [:edit, :update]

  def index

  end

  def new
    @user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App, #{@user.name}!"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Account updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Checks if a user is logged in.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in before access that page!"
        store_location
        redirect_to login_path
      end
    end

    # Confirms the correct user is logged in.
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
