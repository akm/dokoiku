class UpdateUsers < ActiveRecord::Migration

  def self.up
    change_column 'users', 'address',   :integer
  end
  
  def self.down
    change_column 'users', 'address',   :string
  end

end