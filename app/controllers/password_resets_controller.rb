class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instruction."
      redirect_to root_path
    else
      flash.now[:danger] = "Email not found!"
      render 'new'
    end
  end

  def edit
  end

  private
    # Gets the user from params.
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirm a valid user.
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        flash[:danger] = "Invalid password reset link!"
        redirect_to root_path
      end
    end
end
