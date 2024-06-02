
RedmineApp::Application.routes.draw do
  match 'projects/:project_id/service-assistant/services', :controller => 'services',
        :action => 'index', via: [:get]
  match 'projects/:project_id/service-assistant/services', :controller => 'services',
        :action => 'create', via: [:post]
  match 'projects/:project_id/service-assistant/services/new', :controller => 'services',
        :action => 'new', via: [:get]
  match 'projects/:project_id/service-assistant/services/:id', :controller => 'services',
        :action => 'show', via: [:get]
  match 'projects/:project_id/service-assistant/services/:id/edit', :controller => 'services',
        :action => 'edit', via: [:get]
  match 'projects/:project_id/service-assistant/services/:id/setting', :controller => 'services',
        :action => 'setting', via: [:get]
end
