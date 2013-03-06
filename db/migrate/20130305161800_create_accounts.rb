class CreateAccounts < ActiveRecord::Migration
  def self.change
    create_table(:accounts) do |t|
      t.string   :uid, :limit => 50, :null => false
      t.string   :name,        
      t.string   :email,       
      t.string   :photo_url
      t.string   :link
      t.string   :login,        
      t.string   :gender, :limit => 10
      t.string   :token

      t.timestamps
    end
    
    add_index :accounts, :uid, :unique => true
  end
end