class UsersController < ApplicationController
  #before_filter :authenticate_user!
  respond_to :json, :html

  allow_oauth! :except => :delete

  def show
	@user = User.find(params[:id])
	@posts = @user.posts.page(params[:page]).per_page(10)
end
end
