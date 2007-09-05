class RecommendController < ApplicationController

  def index
    redirect_to :action => 'question'
  end

  def question
    @question = Course::Finder.new(
      :start_y => '32.74207489599587', :start_x => '129.87160563468933')
    if request.get?
      render :action => 'question'
    else
      render :action => 'result'
    end
  end

  def result
  end
end
