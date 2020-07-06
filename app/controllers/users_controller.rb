class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  before_action :activated_user,  only: [:index, :update]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    if logged_in?
      redirect_to home_path
    else
      @user = User.new
    end
  end

  def show
  	@user = User.find_by("lower(username) = ?", params[:username].downcase)
    @user ||= User.new(username: params[:username])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account, #{@user.name}!"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by("lower(username) = ?", params[:username].downcase)
  end

  def update
    @user = User.find_by("lower(username) = ?", params[:username].downcase)
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

  def following
    @user = User.find_by("lower(username) = ?", params[:username].downcase)

    if @user.nil?
      @user= User.new(username: params[:username])
      render 'show' and return
    end

    if logged_in?
      @title = "Following"
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_to @user
    end
  end

  def followers
    @user = User.find_by("lower(username) = ?", params[:username].downcase)

    if @user.nil?
      @user= User.new(username: params[:username])
      render 'show' and return
    end

    if logged_in?
      @title = "Followers"
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_to @user
    end
  end

  def media
    @user = User.find_by("lower(username) = ?", params[:username].downcase)

    if @user.nil?
      @user= User.new(username: params[:username])
      render 'show' and return
    end

    if logged_in?
      @microposts = @user.media.paginate(page: params[:page])
      render 'show'
    else
      redirect_to @user
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms the correct user is logged in.
    def correct_user
      @user = User.find_by("lower(username) = ?", params[:username].downcase)
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
