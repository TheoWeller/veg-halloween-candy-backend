class Api::V1::PostsController < ApplicationController
  def index
    byebug
    render json: Post.all
  end

  def update

  end

  def delete

  end

  def create

  end
end
