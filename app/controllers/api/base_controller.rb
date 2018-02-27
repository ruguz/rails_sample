class Api::BaseController < ApplicationController
  # 例外処理
  # 定義の逆順で呼ばれる
  rescue_from Error::ApplicationError, with: :application_error

  # actions
  before_action :parse_request

  attr_reader :current_user

  def render_response(body: nil, exception: nil)
    @api_request.set_response_header(response, exception: exception) if @api_request
    res = get_response_body(body, exception)
    status = get_response_status(exception)
    respond_to do |format|
      format.json do
        render_json(res, status)
      end
    end
  end

  def with_uuid_lock(uuid)
    return yield if uuid.blank?
    User.lock.find(uuid: uuid) do
      yield
    end
  end

  private

  def parse_request
    @api_request = ApiRequest.new(request, params)
    @current_user = @api_request.user
  end

  def render_json(res, status)
    unless res
      render nothing: true, status: status
      return
    end
    render json: res, status: status
  end

  def application_error(exeption)
    render_response(exception: exeption)
  end

  def get_response_body(body, exception)
    return body unless exception
    nil
  end

  def get_response_status(exception)
    return :ok unless exception
    :bad_request
  end
end
