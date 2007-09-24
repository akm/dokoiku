# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 7) do

  create_table "course_entries", :force => true do |t|
    t.column "course_id", :integer
    t.column "line_no",   :integer
    t.column "spot_id",   :integer
  end

  create_table "course_ratings", :force => true do |t|
    t.column "user_id",    :integer, :null => false
    t.column "course_id",  :integer, :null => false
    t.column "rating",     :integer, :null => false
    t.column "created_at", :time
    t.column "updated_at", :time
  end

  create_table "courses", :force => true do |t|
    t.column "name",       :string,  :limit => 200
    t.column "comment",    :text
    t.column "points",     :integer,                :default => 0, :null => false
    t.column "creator_id", :integer
    t.column "created_at", :time
    t.column "updated_at", :time
    t.column "feeling_x",  :integer
    t.column "feeling_y",  :integer
    t.column "purpose_cd", :integer
  end

  create_table "spots", :force => true do |t|
    t.column "latitude",   :float
    t.column "longitude",  :float
    t.column "name",       :string, :limit => 200
    t.column "comment",    :text
    t.column "created_at", :time
    t.column "updated_at", :time
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string
    t.column "email",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
    t.column "name",                      :string
    t.column "sex",                       :integer
    t.column "age",                       :integer
    t.column "address",                   :integer
  end

end
