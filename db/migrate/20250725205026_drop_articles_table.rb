class DropArticlesTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :articles, :comments
  end
end
