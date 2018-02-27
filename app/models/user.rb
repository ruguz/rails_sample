# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  uuid          :string(100)      not null              # UUID
#  tag_name      :string(255)      not null              # タグ名
#  name          :string(100)      not null              # ユーザ-名
#  device_type   :integer          not null              # デバイス種別
#  user_type     :integer          not null              # ユーザ-タイプ
#  registered_at :datetime         not null              # 作成日
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ApplicationRecord
  # UUIDフォーマット
  UUID_FORMAT = /\A[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}\z/i
  USER_TYPE = Utils::Enum.create(
    normal:   {enum: 1, name: "一般ユーザー"}
  )
  DEVICE_TYPE = Utils::Enum.create(
    ios:      {enum: 1, name: "iOS"},
    android:  {enum: 2, name: "Android"}
  )
  class << self
    def register!(uuid, name, device_type, user_type: nil)
      user = self.new
      user.register!(uuid, name, device_type, user_type: user_type)
      user
    end

    def generate_tag_name(user_id, length = 6)
      s = Random.new("#{Random.new_seed}+#{user_id.to_i}".to_i ).rand(34**length).to_s(34)
      s = s.rjust(length, "0")
      s.gsub!("0", "y") # rubocop:disable Performance/StringReplacement
      s.gsub!("1", "z") # rubocop:disable Performance/StringReplacement
      s.upcase!
      s
    end
  end

  def register!(uuid, name, device_type, user_type: nil)
    validate(uuid, name, device_type)
    user_type ||= USER_TYPE.get_enum_by_key(:normal)
    self.uuid = uuid
    self.name = name
    self.device_type = device_type
    self.user_type = user_type
    self.registered_at = Time.current
    self.tag_name = "";
    self.save!
    true
  end

  def generate_tag_name!
    self.tag_name = self.class.generate_tag_name(self.id)
  end

  private

  def validate(uuid, name, device_type)
    validate_uuid(uuid)
    validate_name(name)
    validate_device_type(device_type)
    true
  end

  def validate_uuid(uuid)
    raise Error::Request::InvalidParamsError unless valid_uuid_format?(uuid)
    raise Error::User::UUIDAlreadyUsed unless valid_uuid_unique?(uuid)
  end

  def validate_name(name)
    raise Error::User::InvalidNameError unless valid_name?(name)
  end

  def validate_device_type(device_type)
    raise Error::Request::InvalidParamsError unless valid_device_type?(device_type)
  end

  def valid_uuid_format?(uuid)
    unless uuid
      logger.debug('uuid is nil.')
      return false
    end
    unless UUID_FORMAT.match(uuid)
      logger.debug('uuid format is not match.')
      return false
    end
    true
  end

  def valid_uuid_unique?(uuid)
    return false if uuid.blank?
    User.exists?(uuid: uuid) ? false : true
  end

  def valid_name?(name)
    return false if name.blank?
    return false if name.length < 0 || name.length > 10
    true
  end

  def valid_device_type?(device_type)
    DEVICE_TYPE.enums.include?(device_type) ? true : false
  end
end
