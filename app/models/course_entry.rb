class CourseEntry < ActiveRecord::Base

  belongs_to :course
  belongs_to :spot

end
