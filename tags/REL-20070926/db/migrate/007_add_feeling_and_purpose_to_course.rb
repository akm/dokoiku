class AddFeelingAndPurposeToCourse < ActiveRecord::Migration
  class Course < ActiveRecord::Base
  end
  
  def self.up
    add_column 'courses', 'feeling_x',  :integer
    add_column 'courses', 'feeling_y',  :integer
    add_column 'courses', 'purpose_cd', :integer
    Course.find(:all).each_with_index do |course, index|
      course.purpose_cd = 1 # デート
      course.feeling_x = 35 + index # 数値に特に意味はないです
      course.feeling_y = 35 - index # 数値に特に意味はないです
      course.save!
    end
  end

  def self.down
    remove_column 'courses', 'feeling_x'
    remove_column 'courses', 'feeling_y'
    remove_column 'courses', 'purpose_cd'
  end
end
