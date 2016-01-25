class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.string :filter_m

      t.timestamps
    end
  end
end
