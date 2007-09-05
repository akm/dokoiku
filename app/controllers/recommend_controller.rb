class RecommendController < ApplicationController

  def index
    redirect_to :action => 'question'
  end

  def question
    if request.get?
      render :action => 'question'
    else
      render :action => 'result'
    end
  end

  def result
  end
end
