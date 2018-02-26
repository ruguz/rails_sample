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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
