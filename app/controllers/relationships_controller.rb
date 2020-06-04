class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    other_user = User.find(params[:followed_id])
    current_user.follow(other_user)
    redirect_to other_user
  end

  def destroy
    other_user = Relationship.find(params[:id]).followed
    current_user.unfollow(other_user)
    redirect_to other_user
  end
end
