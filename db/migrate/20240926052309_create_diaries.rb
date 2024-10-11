class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :keyword
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
