class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :spelling
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
