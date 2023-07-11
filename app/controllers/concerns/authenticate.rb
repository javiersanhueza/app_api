module Authenticate
  def current_user
    auth_token = request.headers['Authorization']
    return unless auth_token
    @current_user = User.find_by(authentication_token: auth_token)
  end

  def authentication_with_token!
    return if current_user
    json_response('Unauthenticated', false, {}, :unauthorized)
  end

  def correct_user?(user)
    user.id == current_user.id
  end
end