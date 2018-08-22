class QuestionsController < ApplicationController
  before_action :load_question, only: %i(show update edit)

  def show; end

  def index
    @questions = Question.all.page(params[:page]).per Settings.number_page
  end

  def new
    @question = Question.new
    (Settings.number_answer).times {@question.answers.build}
  end
    
  def edit; end

  def create
    @question = Question.new params_question
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(params[:question])
      redirect_to @question
    else
      render :edit
    end
  end

  private
  def params_question
    params.require(:question).permit :word, :category_id,
      answers_attributes: [:id, :mean, :correct]
  end

  def load_question
    @question = Question.find_by id: params[:id]
  end
end
