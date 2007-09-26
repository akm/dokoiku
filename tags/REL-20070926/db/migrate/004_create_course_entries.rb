class CreateCourseEntries < ActiveRecord::Migration
  class CourseEntry < ActiveRecord::Base
  end
  class Spot < ActiveRecord::Base
  end
  
  def self.up
    create_table :course_entries do |t|
      t.column :course_id, :integer
      t.column :line_no, :integer
      t.column :spot_id, :integer
    end
    Spot.find(:all).each do |spot|
      CourseEntry.create(
        :spot_id => spot.id,
        :course_id => spot.course_id,
        :line_no => spot.line_no)
    end
    
    remove_column 'spots', 'course_id'
    remove_column 'spots', 'line_no'
  end

  def self.down
    add_column 'spots', "course_id",   :integer
    add_column 'spots', "line_no",     :integer
    add_column 'spots', "spot_id",     :integer

    CourseEntry.find(:all).each do |entry|
      spot = Spot.find(entry.spot_id)
      spot.attributes = {
        :course_id => entry.course_id,
        :line_no => entry.line_no}
      spot.save!
    end
    
    drop_table :course_entries
  end
end
