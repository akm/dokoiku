class CreateSpots < ActiveRecord::Migration
  def self.up
    create_table :spots do |t|
      t.column :course_id, :integer
      t.column :line_no, :integer
      t.column :latitude, :float
      t.column :longitude, :float
      t.column :name, :string, :limit => 200
      t.column :comment, :text
      t.column :created_at, :time
      t.column :updated_at, :time
    end
  end

  def self.down
    drop_table :spots
  end
end
