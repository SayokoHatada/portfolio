class AddCorrectedBodyToDiaries < ActiveRecord::Migration[7.2]
  def change
    add_column :diaries, :corrected_body, :text
  end
end
