class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.integer :video_id, :category_id

      t.timestamps
    end
  end
end
