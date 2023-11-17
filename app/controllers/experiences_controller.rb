class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :categories, only: [:index, :edit]
  before_action :set_experience, only: [:show, :edit, :update]

  def index
    @favorite = Favorite.new
    @favorites = Favorite.where(user: current_user)

    @experiences = Experience.all

    if params[:min_price].present?
      min_price = params[:min_price].to_i
      max_price = params[:max_price].to_i
      @experiences = @experiences.where("price >= ? AND price <= ?", min_price, max_price)
    end

    if params[:category].present?
      @experiences = @experiences.where("category = ?", params[:category])
    end

    if params[:query].present?
      @experiences = @experiences.where("description LIKE ?", "%#{params[:query]}%")
    end
  end

  def show
    @booking = Booking.new
    @review = Review.new
    @reviews = @experience.reviews.limit(10)
  end

  def new
    @experience = Experience.new
    @categories = ["Jousting", "Archery", "Samurai", "Vikings", "Knights", "Ninja"]
  end

  def create
    @experience = Experience.new(experience_params)
    @experience.host = current_user

    if @experience.save
      redirect_to host_experiences_path(@experience)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @experience.update(experience_params)
    if @experience.save
      redirect_to host_experiences_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def experience_params
    params.require(:experience).permit(:name, :description, :price, :category, :address, :photo)
  end

  def set_experience
    @experience = Experience.find(params[:id])
  end

  def categories
    @categories = ["Jousting", "Archery", "Samurai", "Vikings", "Knights", "Ninja"]
  end
end
