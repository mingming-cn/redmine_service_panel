class CreateServicePanelTriggers < ActiveRecord::Migration[6.1]
  def change
    create_table :service_panel_triggers do |t|
      t.string :trigger_name, null: false
      # 当 project_id 为 0 时，表示为全局触发器
      t.integer :project_id, null: false
      t.string :condition, null: false
      t.text :before_script, null: true
      t.string :environment, null: false
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: true
    end
  end
end
