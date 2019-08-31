class Api::V1::PostsController < ApplicationController
  def index
    render json: Post.all
  end

  def update
    @post = Post.find_by(id: params["payload"]["id"])
    @user = User.find_by(id: @post.user_id)
    @post.update(
      title: params["payload"]["title"],
      content_body: params["payload"]["content_body"],
      image_url_1: params["payload"]["image_url_1"],
      image_url_2: params["payload"]["image_url_2"],
      referral_link: params["payload"]["referral_link"]
    )
    if @post
      @post.draft = false
      adjustPostRankings("update")
      render json: {status: "edited", payload: @user.posts}
    else
      render json: {error: @post.errors.messages}
    end
  end

  def delete
    @post = Post.find_by(id: params["payload"]["postId"])
    @user = User.find_by(id: params["payload"]["userId"])
    adjustPostRankings("delete")
    @post.destroy!
    @all_posts = @user.posts
    if !Post.exists?(@post.id)
      render json: {status: "deleted", payload: @all_posts}
    end
  end

  def save_draft
    @token = request.headers["Authenticate"]
    @user = User.find_by(id: decode_token["id"])
      if @user
        @post = Post.new(
          title: params["payload"]["title"],
          content_body: params["payload"]["content_body"],
          image_url_1: params["payload"]["image_url_1"],
          image_url_2: params["payload"]["image_url_2"],
          referral_link: params["payload"]["referral_link"],
          user_id: @user.id
        )
          if @post
            @post.draft = true
            @post.rank = 0
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
        content_body: params["payload"]["content_body"],
        image_url_1: params["payload"]["image_url_1"],
        image_url_2: params["payload"]["image_url_2"],
        referral_link: params["payload"]["referral_link"],
        user_id: @user.id
      )
        if @post
          @post.draft = false
          #if post has no rank set it deafults to 1 -
          params["payload"]["rank"] == "" && params["payload"]["rank"] = @post.rank.to_s
          adjustPostRankings("create")
          @post.save
          render json: {status: "success", payload: @user.posts}
        end
    else
      render json: {error: "Not authorized"}
    end
  end
end
