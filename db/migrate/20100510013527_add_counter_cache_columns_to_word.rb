class AddCounterCacheColumnsToWord < ActiveRecord::Migration
  def self.up
    add_column :words, :lookup_count, :integer
    add_column :words, :favorite_count, :integer
    add_column :words, :list_count, :integer
    add_column :words, :comment_count, :integer

    add_index :words, :lookup_count
    add_index :words, :favorite_count
    add_index :words, :list_count
    add_index :words, :comment_count
  end

  def self.down
    remove_column :words, :lookup_count
    remove_column :words, :favorite_count
    remove_column :words, :list_count
    remove_column :words, :comment_count

    remove_index :words, :lookup_count
    remove_index :words, :favorite_count
    remove_index :words, :list_count
    remove_index :words, :comment_count
  end
end
