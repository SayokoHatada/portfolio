class Diary < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 225 }
  validates :body, presence: true, length: { minimum: 50, maximum: 2000 }
end
