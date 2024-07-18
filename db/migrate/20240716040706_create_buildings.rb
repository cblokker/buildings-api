class CreateBuildings < ActiveRecord::Migration[7.1]
  def change
    create_table :buildings do |t|
      t.references :client, null: false, foreign_key: true
      t.jsonb :custom_fields, null: false, default: {}

      t.timestamps
    end

    add_index :buildings, :custom_fields, using: :gin
  end
end
