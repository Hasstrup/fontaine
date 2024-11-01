# frozen_string_literal: true

module Authorization
  def current_user
    @current_user ||= user_from_token
  end

  def bearer_token
    @bearer_token ||= begin
      pattern = /^Bearer /
      header = request.headers['Authorization']
      header.gsub(pattern, '') if header&.match(pattern)
    end
  end

  def including_current_user(body)
    body&.merge(user_id: current_user.id)
  end

  private

  def user_from_token
    @user_from_token ||= if (payload = Encryption::TokenManager.token_2_payload(bearer_token))
                           ::User.find_by(id: payload.symbolize_keys.dig(:id))
                         end
  end
end
