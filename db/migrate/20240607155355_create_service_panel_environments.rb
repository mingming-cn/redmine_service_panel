class CreateServicePanelEnvironments < ActiveRecord::Migration[6.1]
  def change
    create_table :service_panel_environments do |t|
      t.string :name, null: false
      # 当 service_id 为 0 时，表示为全局环境
      t.integer :service_id, null: false
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: true
    end
  end
end
