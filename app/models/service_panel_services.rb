class ServicePanelServices < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project

  validates_presence_of :project_id, :name, :git_repo_url, :git_access_token

  def editable?(usr=nil)
    (usr || User.current).allowed_to?(:update_services, self.project)
  end

  def visible?(usr=nil)
    (usr || User.current).allowed_to?(:view_services, self.project)
  end
end
