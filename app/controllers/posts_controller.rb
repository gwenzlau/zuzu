class PostsController < ApplicationController
	  respond_to :json, :html


  def index
  	lat, lng = params[:lat], params[:lng]
    if lat and lng
    @posts = Post.nearby(lat.to_f, lng.to_f)
    respond_with({:posts => @posts}.as_json)
else
	respond_with({:message => "Invalid or missing lat/lng params"}, :status => 400)
	end
  end

  def show
    @post = Post.find(params[:id])
    respond_with(@post)
  end

  def create
    @post = Post.create(params[:post])
    respond_with(@post)
  end
end
