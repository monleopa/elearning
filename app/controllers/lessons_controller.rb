class LessonsController < ApplicationController
  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new params_lesson
    if @lesson.save
      redirect_to @lesson
    else
      render :new
    end
  end

  def show
    @lesson = Lesson.find_by id: params[:id]
    @category = @lesson.category
    @questions = @category.questions

    number_question = 0
    @questions.each do |question|
      @question = question
      number_question = number_question + 1
    end

    number_question.times{@result = Result.new}
  end

  def index
    @lessons = Lesson.all
  end

  private
  def params_lesson
    params.require(:lesson).permit :name, :category_id
  end
end
