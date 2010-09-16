class CreateQueries < ActiveRecord::Migration
  def self.up
    create_table :queries do |t|
      t.string :q
      t.integer :result_count
      t.string :ip
    
      t.timestamps
    end
    add_index :queries, :q
    add_index :queries, :result_count
    add_index :queries, :ip
  end

  def self.down
    drop_table :queries
  end
end
