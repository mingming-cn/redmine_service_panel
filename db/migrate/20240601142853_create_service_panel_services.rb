class CreateServicePanelServices < ActiveRecord::Migration[6.1]
  def change
    create_table :service_panel_services do |t|
      t.string :name, null: false
      t.integer :project_id, null: false
      t.string :git_repo_url, null: false
      t.string :git_access_token, null: false
      # git_repo_id 通过 gitlab api 获取， 无需手动填写
      t.integer :git_repo_id, null: false
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: true
    end
  end
end
