class CreatePicturesUsers < ActiveRecord::Migration
  def change
    create_table :pictures_users do |t|
          
      t.timestamps
    end
  end
end
