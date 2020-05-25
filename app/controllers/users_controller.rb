class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  before_action :activated_user,  only: [:index, :update]

  def index
    @users = User.paginate(page: params[:page])
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
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account, #{@user.name}!"
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_path
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

    # Confirms the logged in user is an admin
    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    # Confirms the logged in user is activated.
    def activated_user
      unless current_user.activated?
        flash[:warning] = "Account unactivated! Please activate your account!"
        redirect_to root_path
      end
    end
end
