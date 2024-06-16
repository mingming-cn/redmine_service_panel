class CreateServicePanelEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :service_panel_events do |t|
      # 当 service_id 为 0 时，表示为全局事件
      t.integer :service_id, null: false
      t.string :event_name, null: false
      t.string :user_email, null: false
      t.text :trigger_content, null: false
      t.timestamp :created_at, null: false
    end
  end
end
