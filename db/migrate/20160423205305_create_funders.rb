class CreateFunders < ActiveRecord::Migration
  def change
    create_table :funders do |t|
      t.string :name, null: false
      t.string :url

      t.timestamps null: false
    end

    add_index :funders, :name, unique: true
    add_index :funders, :url
  end
end
