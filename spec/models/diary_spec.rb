require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe "バリデーションチェック" do
    it "設定した全てのバリデーションが機能しているか" do
      long_body = "a" * 50
      diary = build(:diary, body: long_body)
      expect(diary).to be_valid
      expect(diary.errors).to be_empty
    end

    it "titleがない場合にバリデーションが機能してinvalidになるか" do
      diary_without_title = build(:diary, title: "")
      expect(diary_without_title).to be_invalid
      expect(diary_without_title.errors[:title]).to eq [ "タイトルを入力してください" ]
    end

    it "bodyが50文字未満の場合、バリデーションエラーが出るか" do
      diary_with_less_than_50 = build(:diary, body: "hello")
      expect(diary_with_less_than_50).to be_invalid
      expect(diary_with_less_than_50.errors[:body]).to eq [ "Bodyは50文字以上で入力してください" ]
    end

    it 'bodyが2000文字以上の場合、バリデーションエラーが発生するか' do
      long_body = "a" * 2001
      diary_with_more_than_2000 = build(:diary, body: long_body)
      expect(diary_with_more_than_2000).not_to be_valid
      expect(diary_with_more_than_2000.errors[:body]).to eq [ "Bodyは2000文字以下で入力してください" ]
    end
  end
end
