class PostsController < ApplicationController
	  respond_to :json, :html
    before_filter :authenticate_user!, except: [:index]


  def index
  #	lat, lng = params[:lat], params[:lng]
   # if lat and lng
  #@posts = Post.nearby(lat.to_f, lng.to_f)
  #  respond_with({:posts => @posts}.as_json)
#else
#	respond_with({:message => "Invalid or missing lat/lng params"}, :status => 400)
#	end
#@posts = Post. order("created_at desc")
 @posts = Post.all
  respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    @post = Post.find(params[:id])
   # respond_with(@post)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
  def new
    @post = current_user.posts.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end
  def create
    puts params
    @post = current_user.posts.new(params[:post])
  #  @post = Post.create(params["post"])
  #  respond_with(@post)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      #  redirect_to @user
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @posts.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
