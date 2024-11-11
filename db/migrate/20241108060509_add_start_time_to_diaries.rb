class AddStartTimeToDiaries < ActiveRecord::Migration[7.2]
  def change
    add_column :diaries, :start_time, :datetime
  end
end
