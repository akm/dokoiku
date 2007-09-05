class RecommendController < ApplicationController

  def index
    redirect_to :action => 'question'
  end

  def question
    if request.get?
      @question = Course::Finder.new(
        :start_y => '32.74207489599587', :start_x => '129.87160563468933')
      render :action => 'question'
    else
      @question = Course::Finder.new(params[:question])
      render :action => 'result'
    end
  end

  def result
  end
end
