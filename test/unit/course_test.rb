require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < Test::Unit::TestCase
  fixtures :courses, :course_entries, :spots, :users

  def test_find_match
    finder_attrs = {
      :start_x => "129.86897706985474",
      :start_y => "32.74150637132022",
      :feeling_x =>"39",
      :feeling_y => "29",
      :budget_cd => "4",
      :purpose_cd => "1"}
      
    finder = Course::Finder.new(finder_attrs)
    courses = Course.find(:all, finder.to_find_options)
    assert_equal 3, courses.length
  end
end
