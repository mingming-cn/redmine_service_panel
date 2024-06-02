module ServicesHelper
  class LinkObj
    attr_accessor :name, :title, :url

    def initialize(name, title, url)
      @name = name
      @title = title
      @url = url
    end
  end

  def sidebar_links
    [
      LinkObj.new('service', l(:sidebar_text_services), url_for(:controller => 'services', :action => :index)),
      LinkObj.new('environment' , l(:sidebar_text_environment), url_for(:controller => 'services', :action => :index)),
      LinkObj.new('event', l(:sidebar_text_event), url_for(:controller => 'services', :action => :index)),
    ]
  end

  def cancel_button_tag_for_service()
    cancel_button_tag(url_for(:controller => 'services', :action => :index))
  end
end
