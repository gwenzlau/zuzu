class UsersController < ApplicationController
  #before_filter :authenticate_user!
  respond_to :json, :html, :xml

  allow_oauth! :except => :delete

  def show
	@user = User.find(params[:id])
	@posts = @user.posts
  end

  respond_to :json, :xml
  def index
    @users = User.all
    respond_with(@users)
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    respond_to do |format|
      format.json do
        render :json => @user.to_public_json
      end
      format.html do
        render :edit
      end
    end
  end
end
