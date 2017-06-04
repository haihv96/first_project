class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :context
      t.belongs_to :user

      t.timestamps
    end
  end
end
