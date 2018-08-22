class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new params_category
    if @category.save
      flash[:success] = t ".success"
      redirect_to @category
    else
      render :new
    end
  end

  def show
    @category = Category.find_by id: params[:id]
    @questions = @category.questions
  end

  def index
    @categories = Category.all
  end

  private
  def params_category
    params.require(:category).permit :name
  end
end
