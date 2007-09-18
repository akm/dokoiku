class UpdateUsers < ActiveRecord::Migration

  def self.up
    add_column 'users', 'name',     :string
    add_column 'users', 'sex',      :integer
    add_column 'users', 'age',      :integer
    add_column 'users', 'address',  :integer
  end
  
  def self.down
    remove_column 'users', 'name'
    remove_column 'users', 'sex'
    remove_column 'users', 'age'
    remove_column 'users', 'address'
  end

end
