class CatsController < ApplicationController

  before_action :set_cat, only: [:edit, :update]
  before_action :validate_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.includes(:rental_requests => [:user]).find(params[:id])
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)

    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  def set_cat
    @cat = Cat.find(params[:id])
  end

  def validate_owner
    unless @cat.owner == current_user
      flash[:errors] = ["You can't edit someone else's cat!"]
      redirect_to cats_url
    end
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex, :picture)
  end
end
