require 'redmine'
require_relative 'lib/redmine_service_assistant'


Redmine::Plugin.register :redmine_service_assistant do
  name 'Redmine service assistant plugin'
  author 'mingming.wang'
  description 'This is a plugin of service assistant for Redmine'
  version '0.0.1'
  url 'https://github.com/mingming-cn/redmine_service_assistant'
  author_url 'https://mingming.wang'
  project_module :service_assistant do
    permission :view_services, services: %i[index show setting]
    permission :add_services, services: %i[create new]
    permission :update_services, services: %i[update]
  end
  menu :project_menu, :service_assistant, { controller: 'services', action: 'index' },
       caption: :menu_service_assistant, after: :calendar, param: :project_id
end
