
class ServicesController < ApplicationController
  include ServicesHelper
  include Redmine::SafeAttributes

  before_action :find_project, :authorize, :build_sidebar_links
  before_action :find_service, :only => [:show, :edit, :update, :setting]
  before_action :build_new_from_params, :only => [:new, :create]
  accept_api_auth :index, :create
  menu_item :service_panel

  def index
    @services = ServicePanelServices.all

    respond_to do |format|
      format.html do
      end
      format.api do
      end
    end
  end

  def new; end

  def create
    raise ::Unauthorized unless User.current.allowed_to?(:add_services, @project)

    if @service.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_service_successful_create)
          if params[:continue]
            redirect_to url_for(:controller => :services, :action => :new)
          else
            redirect_to url_for(:controller => :services, :action => :show, :id => @service.id)
          end
        end
      end
      return
    end

    respond_to do |format|
      format.html do
        render :action => 'new'
      end
      format.api  {render_validation_errors(@service)}
    end
  end

  def show; end

  def edit; end

  def update
    @service.git_repo_url = params[:service_panel_services][:git_repo_url]
    @service.git_access_token = params[:service_panel_services][:git_access_token]
    if @service.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to url_for(:controller => :services, :action => :edit, :id => @service.id, :project_id => @project)
        end
        format.api {render_api_ok}
      end
    else
      respond_to do |format|
        format.html {render :action => 'edit'}
        format.api  {render_validation_errors(@service)}
      end
    end
  end

  private

  def build_sidebar_links
    @sidebar_links = sidebar_links
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

  def find_service
    @service = ServicePanelServices.find(params[:id])
    raise Unauthorized unless @service.visible?
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def build_new_from_params
    @service = ServicePanelServices.new
    @service.project = @project
    @service.created_at ||= Time.now

    attrs = (params[:service_panel_services] || {}).deep_dup
    @service.name= attrs[:name]
    @service.git_repo_url = attrs[:git_repo_url]
    @service.git_access_token = attrs[:git_access_token]
  end

end
