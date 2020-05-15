module Api::V1
  class BaseAPIController < ActionController::API
    before_action :require_authentication!
    before_action :require_json_content_type!

    def return_json(response_body, response_status = :ok)
      render(json: response_body, status: response_status)
    end

    def return_unauthorized_response
      return_json(
        {
          (I18n.t('api.response.type.error')) =>
          I18n.t('api.response.message.invalid_token')
        }, :unauthorized
      )
    end

    def return_invalid_content_type_response
      return_json(
        {
          I18n.t('api.response.type.error') =>
          I18n.t('api.response.message.invalid_content')
        }, :precondition_failed
      )
    end

    def return_not_found_response(entitie, entitie_id)
      return_json(
        {
        I18n.t('api.response.type.not_found') =>
        "#{I18n.t("api.entitie.#{entitie}")} ID:#{entitie_id}"
        }, :not_found
      )
    end

    def return_deleted_response(entitie, entitie_id)
      return_json(
        {
          I18n.t('api.response.type.deleted') =>
          "#{I18n.t("api.entitie.#{entitie}")} ID:#{entitie_id}"
        }, :accepted
      )
    end

    private

    def require_authentication!
      return_unauthorized_response unless valid_authentication_token?
    end

    def require_json_content_type!
      return_invalid_content_type_response unless valid_content_type?
    end

    def valid_content_type?
      request.headers['Content-Type'] == 'application/json'
    end

    def valid_authentication_token?
      authentication_token = request.headers[:HTTP_AUTHENTICATION_TOKEN]
      authenticated_user = User.find_by(authentication_token: authentication_token)

      authenticated_user.presence
    end
  end
end
