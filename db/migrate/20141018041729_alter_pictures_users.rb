class AlterPicturesUsers < ActiveRecord::Migration
  def change
    add_column("pictures_users","picture_id",:integer)
    add_column("pictures_users","user_id",:integer)
  end
end
