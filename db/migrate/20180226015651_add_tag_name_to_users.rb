class AddTagNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tag_name, :string, null: false, after: :uuid, comment: 'タグ名'

    add_index :users, :tag_name, unique: true
  end
end
