class PostsController < ApplicationController
	  respond_to :json

  def index
    @posts = Post.all
    respond_with({:posts => @posts}.as_json)
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
