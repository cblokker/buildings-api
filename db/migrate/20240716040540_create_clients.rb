class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.jsonb :custom_field_attributes, null: false, default: {}

      t.timestamps
    end
  end
end
