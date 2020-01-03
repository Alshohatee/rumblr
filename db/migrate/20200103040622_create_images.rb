class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :post_id
      t.string :user_id
      t.string :file
      t.timestamps
    end
  end
end
