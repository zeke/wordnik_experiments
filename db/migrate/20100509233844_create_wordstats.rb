class CreateWordstats < ActiveRecord::Migration
  def self.up
    create_table :wordstats do |t|
      t.integer :word_id
      t.integer :lookup_count
      t.integer :favorite_count
      t.integer :list_count
      t.integer :comment_count
      t.timestamps
    end
    add_index :wordstats, :word_id
    add_index :words, :spelling
    add_index :words, :rank    
  end

  def self.down
    drop_table :wordstats
    remove_index :words, :spelling
    remove_index :words, :rank
  end
end
