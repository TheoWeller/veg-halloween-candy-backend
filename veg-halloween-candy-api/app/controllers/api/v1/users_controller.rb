require 'bcrypt'

class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(username: params["username"], email: params["email"])
    @user.password = params["password"]
    @user.save!
    render json: {status: "success"}
  end

  def login
    @user = User.find_by(email: params["email"])
    if @user && @user.authenticate(params["password"])
      @token = issue_token({id: @user.id})
      render json: {
          status: "success",
          current_user: {username: @user.username, id: @user.id},
          token: @token,
          posts: @user.posts
        }
    else
      render json: {status: "Login failed"}
    end
  end

  def auto_login
    @token = params["payload"]
    @user = current_user
    if @user
      render json: {
        status: "success",
        data: @token,
        current_user: {username: @user.username, id: @user.id},
        posts: @user.posts
      }
    else
      render json: {status: "Login failed"}
    end
  end
end
