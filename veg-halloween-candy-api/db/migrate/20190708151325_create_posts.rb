class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content_body
      t.string :image_url_1
      t.string :image_url_2
      t.string :image_path
      t.string :candy_name
      t.string :candy_type
      t.integer :user_id

      t.timestamps
    end
  end
end
