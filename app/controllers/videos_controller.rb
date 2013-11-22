class VideosController < ApplicationController
  before_filter :require_user
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
    @review = Review.where(user_id: current_user.id, video_id: @video.id).first
  end

  def search
    @videos = Video.search_by_title(params[:term])
  end
end