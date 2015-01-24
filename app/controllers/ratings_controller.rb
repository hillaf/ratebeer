class RatingsController < ApplicationController
 # before_action :set_brewery, only: [:show, :edit, :update, :destroy]

  # GET /ratings
  def index
    @ratings = Rating.all
  end

  # GET /rating/1
  # GET /rating/1.json
  def show
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /rating/1/edit
  def edit
  end

  def create
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end

end