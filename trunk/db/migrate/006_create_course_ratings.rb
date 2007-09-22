class CreateCourseRatings < ActiveRecord::Migration
  def self.up
    create_table :course_ratings do |t|
      t.column 'user_id', :integer, :null => false
      t.column 'course_id', :integer, :null => false
      t.column 'rating', :integer, :null => false
      t.column 'created_at', :time
      t.column 'updated_at', :time
    end
  end

  def self.down
    drop_table :course_ratings
  end
end
