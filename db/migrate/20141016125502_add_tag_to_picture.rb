class AddTagToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :tag, :string
  end
end
