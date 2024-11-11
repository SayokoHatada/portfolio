class Diary < ApplicationRecord
  belongs_to :user
  before_create :set_start_time_to_japanese_time

  validates :title, presence: true, length: { maximum: 225 }
  validates :body, presence: true, length: { minimum: 50, maximum: 2000 }

  private

  def set_start_time_to_japanese_time
    self.start_time = Time.now.in_time_zone("Asia/Tokyo")
  end
end
