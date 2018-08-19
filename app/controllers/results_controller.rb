class ResultsController < ApplicationController
  def new
  end

  def show
  end

  def index
  end

  def create
    @result = Result.new params_result
    if @result.save
    else
      redirect_to lessons_path
    end
  end

  private
  def params_result
    params.require(:result).permit :question_id, :answer_id, :lesson_id
  end
end
