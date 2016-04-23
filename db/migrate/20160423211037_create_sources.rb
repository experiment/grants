class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps null: false
    end

    add_index :sources, :url
    add_index :sources, :name, unique: true
  end
end
