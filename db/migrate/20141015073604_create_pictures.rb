class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :picture_path
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
