class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid,             null: false, limit: 100,  comment: 'UUID'
      t.string :name,             null: false, limit: 100,  comment: 'ユーザ-名'
      t.integer :device_type,     null: false,              comment: 'デバイス種別'
      t.integer :user_type,       null: false,              comment: 'ユーザ-タイプ'
      t.datetime :registered_at,  null: false,              comment: '作成日'

      t.timestamps null: false
    end

    add_index :users, :uuid, unique: true
  end
end
