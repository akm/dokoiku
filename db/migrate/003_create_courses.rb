class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.column :name, :string, :limit => 200
      t.column :comment, :text
      t.column :points, :integer, :null => false, :default => 0
      t.column :creator_id, :integer
      t.column :created_at, :time
      t.column :updated_at, :time
    end
  end

  def self.down
    drop_table :courses
  end
end
