class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_experience, only: :show

  def index
    @categories = ["Jousting", "Archery", "Samurai", "Vikings", "Knights", "Ninja"]
    @experiences = Experience.all
  end

  def show
    @booking = Booking.new()
  end

  private

  def set_experience
    @experience = Experience.find(params[:id])
  end
end