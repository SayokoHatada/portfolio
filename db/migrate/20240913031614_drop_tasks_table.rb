class DropTasksTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :tasks
  end
end
