class StaticPagesController < ApplicationController
  def home
    if request.original_fullpath == '/' and logged_in?
      redirect_to '/home'
    elsif request.original_fullpath == '/home'
      if logged_in?
        @micropost = current_user.microposts.build
        @feed_items = current_user.feed.paginate(page: params[:page])
      else
        logged_in_user
      end
    end
  end

  def help
  end

  def about

  end

  def contact

  end
end
