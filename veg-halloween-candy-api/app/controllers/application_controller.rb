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

  def adjustPostRankings(increment)
    puts "POSTS--------------------------------------: #{@user.posts.length}"
    counter = 0
    puts "LOOP COUNT--------------------------------------: #{counter}"
    @user.posts.each do |p|
      counter + 1
      if p.rank >= @post.rank && p.rank != 0
        puts "BEFORE--------------------------------------:#{p.rank}"
        increment ? p.rank = p.rank + 1 : p.rank = p.rank - 1
        puts "AFTER--------------------------------------:: #{p.rank}"
        p.save
      end
    end
  end

  def shape_create_post_data
    @shapedData = @post.attributes
    @shapedData.delete("user_id")
    @shapedData.delete("created_at")
    @shapedData.delete("updated_at")
    @shapedData
  end
end
