class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]

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
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating  ## virheen aiheuttanut rivi
      session[:last_rating] = @rating.to_s
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