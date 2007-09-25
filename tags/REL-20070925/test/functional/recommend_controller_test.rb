require File.dirname(__FILE__) + '/../test_helper'
require 'recommend_controller'

# Re-raise errors caught by the controller.
class RecommendController; def rescue_action(e) raise e end; end

class RecommendControllerTest < Test::Unit::TestCase
  def setup
    @controller = RecommendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
