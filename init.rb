require 'redmine'

Redmine::Plugin.register :redmine_service_panel do
  name 'Redmine service panel plugin'
  author 'mingming.wang'
  description 'This is a plugin of service panel for Redmine'
  version '0.0.1'
  url 'https://github.com/mingming-cn/redmine_service_panel'
  author_url 'https://mingming.wang'
  project_module :service_panel do
    permission :view_services, services: %i[index show]
    permission :add_services, services: %i[new create]
    permission :update_services, services: %i[edit update]
  end
  menu :project_menu, :service_panel, { controller: 'services', action: 'index' },
       caption: :menu_service_panel, after: :calendar, param: :project_id
end
