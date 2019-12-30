class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :user_id
      t.string :maker
      t.string :image_url
      t.datetime :time_of_creation
      t.integer :num_likes
      t.string :comments
    end
  end
end
