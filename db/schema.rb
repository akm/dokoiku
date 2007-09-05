# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 3) do

  create_table "courses", :force => true do |t|
    t.column "name",       :string,  :limit => 200
    t.column "comment",    :text
    t.column "points",     :integer,                :default => 0, :null => false
    t.column "creator_id", :integer
    t.column "created_at", :time
    t.column "updated_at", :time
  end

  create_table "spots", :force => true do |t|
    t.column "course_id",  :integer
    t.column "line_no",    :integer
    t.column "latitude",   :float
    t.column "longitude",  :float
    t.column "name",       :string,  :limit => 200
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
  end

end
