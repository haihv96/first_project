class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, unique: true
      t.string :email, unique: true
      t.string :password_digest
      t.string :remember_digest
      t.integer :role
      t.timestamps
    end
  end
end
