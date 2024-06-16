module Gitlab
  class Api < HttpHelper
    include Tags
    include Commits
    include Repositories
    include ProjectReleases

    def initialize(gitlab_url, repo_id, access_token)
      super(gitlab_url, access_token)

      @project_id = repo_id.nil? ? get_project_id_by_url(gitlab_url) : repo_id
    end

    # 通过仓库地址获取仓库信息
    def get_project_by_url(repo_url)
      path_encoded = URI.encode_www_form(URI.parse(repo_url).path)
      get("/projects/#{path_encoded}")
    end

    # 通过仓库地址获取仓库ID
    def get_project_id_by_url(repo_url)
      get_project_by_url(repo_url)["id"]
    end

    def get_project(id)
      get("/projects/#{id}")
    end
  end
end
