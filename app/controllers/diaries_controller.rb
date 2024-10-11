class DiariesController < ApplicationController
  def index
    @diaries = Diary.all.includes(:user).order(created_at: :desc)
  end
end
