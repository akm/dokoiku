class CreateCourseEntries < ActiveRecord::Migration
  def self.up
    create_table :course_entries do |t|
    end
  end

  def self.down
    drop_table :course_entries
  end
end
