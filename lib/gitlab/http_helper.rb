module Gitlab
  class HttpHelper
    require 'net/http'
    require 'uri'

    def initialize(gitlab_url, access_token)
      raise 'Gitlab URL is nil' if gitlab_url.nil?
      raise 'Gitlab access token is nil' if access_token.nil?

      @access_token = access_token
      @gitlab_uri = URI.parse(gitlab_url)
      raise "Gitlab URL error: #{@gitlab_uri}" if @gitlab_uri.host.nil?

      @api_url = "#{@gitlab_uri.scheme}://#{@gitlab_uri.host}/api/v4"

      @supported_methods = %w[GET POST PUT PATCH DELETE].freeze
      @supported_body_methods = %w[POST PUT PATCH].freeze
    end

    # Utility method for URL encoding of a string.
    # Copied from https://ruby-doc.org/stdlib-2.7.0/libdoc/erb/rdoc/ERB/Util.html
    #
    # @return [String]
    def url_encode(url)
      url.to_s.b.gsub(/[^a-zA-Z0-9_\-.~]/n) { |m| sprintf('%%%02X', m.unpack1('C')) } # rubocop:disable Style/FormatString
    end

    def build_uri(path, options = {})
      uri = URI.parse(@api_url + path)
      uri.query = URI.encode_www_form(options[:query]) if options[:query]
      uri
    end

    def build_client(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http
    end

    def build_req(method, uri, options = {})
      request = Object.const_get("Net::HTTP::#{method.capitalize}").new(uri.request_uri)
      if @supported_body_methods.include?(method)
        request.body = options[:body].to_json if options[:body]
        request['Content-Type'] = 'application/json'
      end

      request['PRIVATE-TOKEN'] = @access_token
      options[:headers]&.each { |key, value| request[key] = value }
      request
    end

    def send_request(method, path, options = {})
      raise "Unsupported method: #{method}" unless @supported_methods.include?(method)

      uri = build_uri(path, options)
      req = build_req(method, uri, options)
      resp = build_client(uri).request(req)
      raise "Gitlab API error: #{resp.code} #{resp.body}" if resp.code.to_i >= 400

      JSON.parse(resp.body)
    end

    def get(path, options = {})
      send_request('GET', path, options)
    end

    def post(path, options = {})
      send_request('POST', path, options)
    end

    def put(path, options = {})
      send_request('PUT', path, options)
    end

    def delete(path, options = {})
      send_request('DELETE', path, options)
    end

    def patch(path, options = {})
      send_request('PATCH', path, options)
    end

  end
end
