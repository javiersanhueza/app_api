module Response
  def json_response(messages, is_success, data, status)
    render json: {
      messages: messages,
      is_success: is_success,
      data: data
    }, status: status
  end

  def render_rescue(exception)
    Rails.logger.info { "#{exception.message}\n#{exception.backtrace}" }
    render json: {
      message: exception.message,
      is_success: false,
      data: {}
    }, status: :bad_request
  end
end