class Api::V1::PostsController < ApplicationController
  def index
    render json: Post.all
  end

  def update

  end

  def delete

  end

  def create

  end
end
