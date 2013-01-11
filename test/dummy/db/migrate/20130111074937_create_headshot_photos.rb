class CreateHeadshotPhotos < ActiveRecord::Migration
  def change
    create_table :headshot_photos do |t|
      t.string :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.references :capturable, :polymorphic => true
      t.datetime :image_updated_at
      t.timestamps
    end
  end
end
