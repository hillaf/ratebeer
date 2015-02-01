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
    @beers = Beer.all
  end

  # GET /rating/1/edit
  def edit
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating

      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end


  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end