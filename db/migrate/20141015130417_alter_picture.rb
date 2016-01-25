class AlterPicture < ActiveRecord::Migration
  def change
    remove_column("pictures","delete")
    add_column("pictures","mark",:integer)
  end
end
