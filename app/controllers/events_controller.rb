class EventsController < ApplicationController

  before_action :find_project, :find_service, :authorize
  accept_api_auth :create

  def create
    kind = params[:object_kind]

    case kind
    when 'push'
      event_push(params)
    when 'tag_push'
      event_tag_push(params)
    else
      puts "event #{kind} not match anything"
    end

    respond_to do |format|
      format.api do
      end
    end
  end

  def event_push(params = {})
    if params[:before] == '0000000000000000000000000000000000000000'
      puts "event push: #{params[:ref]}, is new branch"
      return
    end

    ref = params[:ref]
    if ref == 'refs/heads/test'
      # test分支，自动创建 tag，格式 test_202404241802
      tag_name = "test_#{Time.now.strftime('%Y%m%d%H%M%S')}"
      tag_msg = extract_commits_msg(params[:commits])
      return @gitlab.create_tag(@service.git_repo_id, tag_name, ref, tag_msg)
    end

    match = ref.match(%r{refs/heads/(v\d+\.\d+\.\d+)_rc})
    if match
      # refs/heads/v1.1.0_rc rc分支
      tag_name = "#{match[1]}_rc_#{Time.now.strftime('%Y%m%d%H%M%S')}"
      tag_msg = extract_commits_msg(params[:commits])
      return @gitlab.create_tag(@service.git_repo_id, tag_name, ref, tag_msg)
    end

    puts "event push: #{ref}, not match anything"
  end

  def event_tag_push(params = {})
    unless params[:checkout_sha]
      # 当前 tag 没有 checkout, 表示是删除事件, 不做任何处理
      puts "tag push: #{params[:ref]}, not checkout sha, is delete tag"
      return
    end

    ref = params[:ref]

    match = ref.match(%r{refs/tags/(v\d+\.\d+\.\d+)})
    unless match
      puts "tag push: #{ref}, not match anything"
      return
    end

    name = match[1]
    note = get_release_note_for_tag(name)
    puts note
    @gitlab.create_project_release(@service.git_repo_id, tag_name: name, description: note)
  end

  private

  def get_release_note_for_tag(tag_name)
    commits = compare_previous_tag(tag_name)
    extract_commits_msg(commits)
  end

  def extract_commits_msg(commits = [], filter_merge_request = true)
    commits.map { |c|
      next if filter_merge_request && c['message'].match(/^Merge branch .+/)

      "- #{c['title']}"
    }.join("\n")
  end

  def compare_previous_tag(tag_name)
    previous_tag = get_previous_tag(tag_name)
    return [] if previous_tag == ''

    result = @gitlab.compare(@service.git_repo_id, previous_tag, tag_name)
    result['commits']
  end

  def get_previous_tag(tag_name)
    @gitlab.tags(@service.git_repo_id, per_page: 50, order_by: 'name').each do |tag|
      name = tag['name']
      return name if name != tag_name && name.match(/^v\d+\.\d+\.\d+$/)
    end

    ''
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end
  def find_service
    @service = ServicePanelServices.find(params[:service_id])

    @gitlab = Gitlab::Api.new(@service.git_repo_url, @service.git_repo_id, @service.git_access_token)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
