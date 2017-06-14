class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :phone
      t.string :address
      t.date :birthday
      t.integer :gender
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
