require 'bcrypt'

class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(username: params["email"]["username"], email: params["email"]["email"])
    @user.password = params["email"]["password"]
    @user.save!
    @token = issue_token({id: @user.id})

    if @user && @token
      render json: {
        status: "success",
        current_user: {username: @user.username, id: @user.id},
        token: @token
      }
    else
      render json: {
        status: "failed to create new user"
      }
    end
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
        token: issue_token({id: @user.id}),
        current_user: {username: @user.username, id: @user.id},
        posts: @user.posts
      }
    else
      render json: {status: "Login failed"}
    end
  end
end
