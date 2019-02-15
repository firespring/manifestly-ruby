require 'faraday'

module Manifestly
  class Client
    DEFAULT_URL = 'https://api.manifest.ly/api'.freeze
    DEFAULT_API_VERSION = 'v1'.freeze

    attr_reader :url, :api_version, :api_key

    def initialize(url: ENV['MANIFESTLY_URL'], api_version: ENV['MANIFESTLY_API_VERSION'], api_key: ENV['MANIFESTLY_API_KEY'])
      @url = url || DEFAULT_URL
      @api_version = api_version || DEFAULT_API_VERSION
      @api_key = api_key || raise('api key is required')
    end

    def get(path, params: {}, headers: {})
      handle_request { raw_get("#{url}/#{api_version}/#{path}", params: params, headers: headers) }
    end

    private def raw_get(path, params: {}, headers: {})
      include_api_key!(params)
      include_json_accept!(headers)
      Faraday.get(path, params, headers)
    end

    def post(path, params: {}, headers: {})
      handle_request { raw_post("#{url}/#{api_version}/#{path}", params: params, headers: headers) }
    end

    private def raw_post(path, params: {}, headers: {})
      include_api_key!(params)
      include_json_content_type!(headers)
      include_json_accept!(headers)
      Faraday.post(path, params.to_json, headers)
    end

    def put(path, params: {}, headers: {})
      handle_request { raw_put("#{url}/#{api_version}/#{path}", params: params, headers: headers) }
    end

    private def raw_put(path, params: {}, headers: {})
      include_api_key!(params)
      include_json_content_type!(headers)
      include_json_accept!(headers)
      Faraday.put(path, params.to_json, headers)
    end

    def delete(path, params: {}, headers: {})
      handle_request { raw_delete("#{url}/#{api_version}/#{path}", params: params, headers: headers) }
    end

    private def raw_delete(path, params: {}, headers: {})
      include_api_key!(params)
      include_json_accept!(headers)
      Faraday.delete(path, params, headers)
    end

    private def include_api_key!(params)
      params.merge!(api_key: api_key)
    end

    private def include_json_content_type!(headers)
      headers.merge!('Content-Type': 'application/json')
    end

    private def include_json_accept!(headers)
      headers.merge!('Accept': 'application/json')
    end

    private def handle_request
      short_response = trim_response(yield)
      case short_response[:status]
      when 404
        raise Faraday::Error::ResourceNotFound, short_response
      when 400...600
        raise Faraday::Error::ClientError, short_response
      end

      short_response
    end

    private def trim_response(full_response)
      {status: full_response.status, headers: full_response.headers, body: full_response.body}
    end
  end
end
