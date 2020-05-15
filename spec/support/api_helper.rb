module ApiHelper
  def get_with_authentication(endpoint, params = nil)
    set_headers_with_auth

    get(endpoint, params: params)
  end

  def post_with_authentication(endpoint, params = nil)
    set_headers_with_auth

    post(endpoint, params: params)
  end

  def put_with_authentication(endpoint, params = nil)
    set_headers_with_auth

    put(endpoint, params: params)
  end

  def delete_with_authentication(endpoint, params = nil)
    set_headers_with_auth

    delete(endpoint, params: params)
  end

  def set_headers_with_auth
     request.headers.merge!(ActionDispatch::Http::Headers.from_hash({
      'Content-Type' => 'application/json',
      'HTTP_AUTHENTICATION_TOKEN' => valid_authentication_token
    }))
  end

  def valid_authentication_token
    @valid_authentication_token ||= create(:user).authentication_token
  end
end
