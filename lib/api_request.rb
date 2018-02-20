class ApiRequest
  include ActiveModel::Model

  attr_reader :req_hash
  attr_reader :user, :device_type

  HEADER_NAME = {
    time: "X-App-Time",                     # 時間
    token: "X-App-Token",                   # リトライ用トークン
    signature: "X-App-Signature",           # シグネチャ
    status: "X-App-Status",                 # スタータス
    error_code: "X-App-Error-Code",         # エラーコード
    device_type: "X-App-Device-Type",       # デバイスタイプ
    user_id: "X-App-User-Id",               # ユーザID
    client_version: "X-App-Client-Version", # クライアントバージョン
    master_version: "X-App-Master-Version", # マスターバージョン
    asset_version: "X-App-Asset-Version"    # アセットバージョン
  }.freeze

  class << self
    def set_header(res, key, val)
      res.headers[HEADER_NAME[key]] = val.to_s
    end

    def set_error_code_header(res, exception)
      set_header(res, :error_code, (exception.try(:error_code) || 1000))
    end
  end

  def initialize(request, params)
    @req_hash = request.uuid
    @req_hash = SecureRandom.uuid if @req_hash.blank?
    @req_time = Time.current
    @remote_ip = request.remote_ip
    @user_agent = request.user_agent
    @api_url = request.fullpath
    @params = params
    @device_type = request_header(request, :device_type).to_i
    user_id = request_header(request, :user_id)
    @user = User.find_by(id: user_id.to_i)
  end

  def set_response_header(response, exception: nil)
    user_id = @user ? @user.id : ""
    set_header(response, :user_id, user_id)
    set_error_code_header(response, exception) if exception
  end

  private

  def request_header(req, key)
    req.headers[HEADER_NAME[key]].to_s
  end

  def set_header(res, key, val)
    self.class.set_header(res, key, val)
  end

  def set_error_code_header(res, ex)
    self.class.set_error_code_header(res, ex)
  end
end
