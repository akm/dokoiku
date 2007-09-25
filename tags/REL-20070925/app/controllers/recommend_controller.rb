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
    @courses = Course.find_with_rating(@question.to_find_options)
    index = (params[:result_index] || 1).to_i - 1
    @course = (index < @courses.length) ? @courses[index] : @courses.first
    if logged_in?
      @rating = CourseRating.find(:first, :conditions => ["course_id = ? and user_id = ?", @course.id, current_user.id]) if @course
      @rating ||= CourseRating.new(:user_id => current_user.id, :course_id => @course.id)
    else
      @rating = nil
    end
    render :action => 'result'
  end
  
  def ajax_post_rating
    if logged_in?
      @rating = params[:id] ? CourseRating.find(params[:id]) : CourseRating.new
      @rating.attributes = params[:rating]
      @rating.user_id = current_user.id
      @rating.save!
    else
      @rating = nil
    end
    render :partial => 'recommend/rating'
  end
end
