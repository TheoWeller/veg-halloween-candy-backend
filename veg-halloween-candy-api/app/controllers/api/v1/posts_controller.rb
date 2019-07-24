class Api::V1::PostsController < ApplicationController
  def index
    render json: Post.all
  end

  def update

  end

  def delete

  end

  def save_draft
    @token = request.headers["Authenticate"]
    @user = User.find_by(id: decode_token["id"])
      if @user
        @post = Post.new(
          title: params["payload"]["title"],
          content_body: params["payload"]["contentBody"],
          image_url_1: params["payload"]["imgUrl1"],
          image_url_2: params["payload"]["imgUrl2"],
          candy_name: params["payload"]["candyType"],
          referral_link: params["payload"]["referralLink"],
          user_id: @user.id
        )
          if @post
            @post.draft = true
            @post.save
            render json: {status: "saved", payload: shape_create_post_data}
          else
            render json: {error: "Missing title."}
          end
      else
        render json: {error: "Failed to save"}
      end
    end


  def create
    @token = request.headers["Authenticate"]
    @user = User.find_by(id: decode_token["id"])
    if @user
      @post = Post.new(
        title: params["payload"]["title"],
        content_body: params["payload"]["contentBody"],
        image_url_1: params["payload"]["imgUrl1"],
        image_url_2: params["payload"]["imgUrl2"],
        candy_name: params["payload"]["candyType"],
        referral_link: params["payload"]["referralLink"],
        user_id: @user.id
      )
        if @post
          @post.draft = false
          @post.save
          render json: {status: "success", payload: shape_create_post_data}
        end
    else
      render json: {error: "Not authorized"}
    end
  end
end
