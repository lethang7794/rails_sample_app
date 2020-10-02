class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user  , only: :destroy

  def index
    redirect_to home_url
  end

  def create
    @micropost = current_user.microposts.build(micropost_param)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created."
      redirect_to home_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      @partial = 'home'
      render 'static_pages/home'
    end
  end

  def show
    @micropost = Micropost.find_by(id: params[:id])
    commontator_thread_show(@micropost)
  end

  def destroy
    @micropost.destroy

    respond_to do |format|
      format.js
      format.html {
        flash[:success] = "Micropost deleted."
        redirect_to root_url
      }
    end
  end

  def upvote
    @micropost = Micropost.find_by(id: params[:id])
    @micropost.liked_by current_user

    respond_to do |format|
      format.js
    end
  end

  def unvote
    @micropost = Micropost.find_by(id: params[:id])
    @micropost.unliked_by current_user

    respond_to do |format|
      format.js
    end
  end

  private
    def micropost_param
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
