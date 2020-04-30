module Api::V1
  class BaseAPIController < ActionController::API
    before_action :require_authentication!
    before_action :require_json_content_type!

    def return_unauthorized_response
      render json: {
        "#{I18n.t('api.response.type.error')}": "#{I18n.t('api.response.message.invalid_token')}"
      }, status: :unauthorized
    end

    def return_invalid_content_type_response
      render json: {
        "#{I18n.t('api.response.type.error')}": "#{I18n.t('api.response.message.invalid_content')}"
      }, status: :precondition_failed
    end

    private

    def require_authentication!
      return_unauthorized_response unless valid_authentication_token?
    end

    def require_json_content_type!
      return_invalid_content_type_response unless valid_content_type?
    end

    def valid_content_type?
      request.headers['Content-Type'] === 'application/json'
    end

    def valid_authentication_token?
      authentication_token = request.headers[:HTTP_AUTHENTICATION_TOKEN]
      authenticated_user = User.find_by(authentication_token: authentication_token)
      
      authenticated_user.presence
    end
  end
end
