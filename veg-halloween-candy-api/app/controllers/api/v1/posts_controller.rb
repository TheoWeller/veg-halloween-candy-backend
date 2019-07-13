class Api::V1::PostsController < ApplicationController
  def index
    byebug
    render json: Post.all
  end

  def update

  end

  def delete

  end

  def save_draft

  end

  def create
    @token = request.headers["Authenticate"]
    @user = User.find_by(id: decode_token["id"])
    if @user
      @post = Post.new(
        title: params["title"],
        content_body: params["contentBody"],
        image_url_1: params["imgUrl1"],
        image_url_2: params["imgUrl2"],
        candy_name: params["candyType"],
        referral_link: params["referralLink"],
        user_id: params["userId"]
      )
        if @post
          @post.draft = false
          @post.save
          render json: {status: "success"}
        else
          render json: {error: "Missing title."}
        end
    else
      render json: {error: "Not authorized"}
    end
  end
end
