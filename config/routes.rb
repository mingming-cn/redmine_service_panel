RedmineApp::Application.routes.draw do
  scope '/projects/:project_id' do
    namespace :service_panel do
      resources :services
    end
  end

  # match 'projects/:project_id/service-panel/services', :controller => 'services',
  #       :action => 'index', via: [:get]
  # match 'projects/:project_id/service-panel/services', :controller => 'services',
  #       :action => 'create', via: [:post]
  # match 'projects/:project_id/service-panel/services/new', :controller => 'services',
  #       :action => 'new', via: [:get]
  # match 'projects/:project_id/service-panel/services/:id', :controller => 'services',
  #       :action => 'show', via: [:get]
  # match 'projects/:project_id/service-panel/services/:id/edit', :controller => 'services',
  #       :action => 'edit', via: [:get]
  # match 'projects/:project_id/service-panel/services/:id', :controller => 'services',
  #       :action => 'update', via: [:patch]
  # match 'projects/:project_id/service-panel/services/:id', :controller => 'services',
  #       :action => 'destroy', via: [:delete]

  match 'projects/:project_id/service_panel/services/:service_id/events', :controller => 'events',
        :action => 'create', via: [:post]
end
