require 'jwt'
class ApplicationController < ActionController::API

  def current_user
      @user ||= User.find_by(id: id_from_token)
  end

  def issue_token(payload)
    JWT.encode(payload, ENV["SECRET_KEY"], 'HS256')
  end

  def decode_token
    begin
      JWT.decode(@token, ENV["SECRET_KEY"], true, {algorithm: 'HS256'}).first
    rescue JWT::DecodeError
      return {id: nil}
    end
  end

  def token
    request.headers["Authenticate"]
  end

  def id_from_token
    @decoded = decode_token
    if @decoded
      @decoded["id"]
    end
  end

  def shape_create_post_data
    @shapedData = @post.attributes
    @shapedData.delete("user_id")
    @shapedData.delete("created_at")
    @shapedData.delete("updated_at")
    @shapedData
  end
#=====POST RANKING HANDLER AND HELPERS=====
def adjustPostRankings(type)
  #all sorted posts
  @sorted_posts = Post.all.sort_by{ |p| p.rank }
  #insert placeholder to represent rankings via index
  @sorted_posts.insert(0, "X")

  case type
    when "create"
      @sorted_posts.insert(params["payload"]["rank"].to_i, @post)
      reassign_and_save_rankings
    when "update"
      @sorted_posts.slice!(@post.rank)
      byebug
      @sorted_posts.insert(params["payload"]["rank"].to_i, @post)
      reassign_and_save_rankings
    when "delete"
      @sorted_posts.slice!(@post.rank)
      reassign_and_save_rankings
  end
end

  def reassign_and_save_rankings
    @sorted_posts.each_with_index do |post, index|
      if post === "X"
        nil
      else
      post.rank = index
      post.save
      end
    end
  end



end
