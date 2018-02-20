class Api::UserController < Api::BaseController
  # railsがデフォルトで使用している認証を使用しない
  protect_from_forgery :except => %i[check register]

  def check
    raise Error::Request::UserNotFound unless current_user
    a = { user: current_user }.to_json
    render_response(body: a)
  end

  def register
    uuid = params[:uuid]
    name = params[:name]
    device_type = @api_request.device_type
    user = User.register!(uuid, name, device_type)
    render_response(body: { user: user }.to_json)
  end
end
