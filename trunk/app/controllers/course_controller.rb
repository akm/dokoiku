require 'json'

class CourseController < ApplicationController

  # include AuthenticatedSystem
  before_filter :login_required

  def index
    redirect_to :action => 'choice'
  end

  def choice
    @course = params[:id] ? Course.find(params[:id]) : nil
    render :action => 'choice'
  end
  
  def ajax_spots
    @course = Course.find(params[:id])
    render :action => 'ajax_spots', :layout => false
  end
  
  def new
    if request.get?
      @course = Course.new
      @course.creator = current_user
      render :action => 'new'
    elsif params[:course_spots].blank?
      flash[:error] = '少なくとも１つはスポットを登録してください'
      @course = Course.new(params[:course])
      @course.creator = current_user
      render :action => 'new'
    else
      @course = Course.new(params[:course])
      @course.creator = current_user
      @course.save_with_spots(JSON.parse(params[:course_spots]))
      if @course.errors.empty?
        redirect_to :action => 'choice', :id => @course.id
      else
        render :action => 'new'
      end
    end
  end
  
end

