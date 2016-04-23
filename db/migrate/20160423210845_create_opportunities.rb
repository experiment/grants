class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.string :name, null: false
      t.integer :funder_id, null: false
      t.datetime :posted_at
      t.datetime :due_at
      t.string :location
      t.integer :number_of_recipients
      t.integer :min_amount, limit: 8
      t.integer :max_amount, limit: 8
      t.integer :total_amount, limit: 8
      t.text :description
      t.string :url
      t.string :foreign_key, null: false
      t.string :contact_name
      t.string :contact_email
      t.string :eligibility_categories
      t.integer :first_source_id, null: false

      t.timestamps null: false
    end

    add_index :opportunities, [:funder_id, :foreign_key], unique: true
  end
end
