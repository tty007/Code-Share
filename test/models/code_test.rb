# == Schema Information
#
# Table name: codes
#
#  id          :integer          not null, primary key
#  filename    :string
#  description :string
#  body        :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uuid        :string           default("b6bae27f-92f1-4523-875d-34e5f528f6ea"), not null
#

require 'test_helper'

class CodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end