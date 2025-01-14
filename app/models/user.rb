class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :diaries, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 5 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: ->  { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: { message: :taken }
  validates :reset_password_token, uniqueness: true, allow_nil: true
end
