module ActiveResource
  class Connection
    # override to allow DELETE with body
    def delete(path, *arguments)
      body = arguments.shift if arguments.length > 1
      headers = arguments[-1] || {}
      with_auth { request(:delete, path, body.to_s, build_request_headers(headers, :delete, self.site.merge(path))) }
    end

    private

    # override to allow DELETE with body
    def request(method, path, *arguments)
      method = method.to_s.upcase
      result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
        payload[:method]      = method
        payload[:request_uri] = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
        arguments.unshift(nil) if arguments.length == 1
        payload[:body]        = arguments[0]
        payload[:result]      = http.send_request(method, path, *arguments)
      end
      handle_response(result)
    rescue Timeout::Error => e
      raise TimeoutError.new(e.message)
    rescue OpenSSL::SSL::SSLError => e
      raise SSLError.new(e.message)
    end
  end
end
