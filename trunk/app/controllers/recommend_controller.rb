class RecommendController < ApplicationController

  def index
    redirect_to :action => 'question'
  end

  def question
    @question = Course::Finder.new(
      :start_y => '32.74207489599587', :start_x => '129.87160563468933')
    render :action => 'question'
  end

  def result
    @question = Course::Finder.new(params[:question])
    @courses = Course.find(:all, @question.to_find_options)
    index = (params[:result_index] || 1).to_i - 1
    @course = (index < @courses.length) ? @courses[index] : @courses.first
    render :action => 'result'
  end
end
