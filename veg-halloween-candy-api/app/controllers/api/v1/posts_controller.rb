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

  end
end
