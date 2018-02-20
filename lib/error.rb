module Error
  class ApplicationError < StandardError
    class_attribute :errcode
    class << self
      # エラーコード定義
      def error_code(code)
        self.errcode = code
      end
    end

    def error_code
      self.class.errcode || 1000
    end
  end

  module Request
    # パラメータが不正
    class InvalidParamsError < ApplicationError
      error_code 1101
    end
    # ユーザが存在しない
    class UserNotFound < ApplicationError
      error_code 1102
    end
  end

  module User
    # UUIDが既に使用済み
    class UUIDAlreadyUsed < ApplicationError
      error_code 1201
    end
  end
end
