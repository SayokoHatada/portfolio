require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    let(:user) { build(:user) }

    context "パスワード関連のバリデーション" do
      it "パスワードが5文字未満の場合、エラーになる" do
        user.password = "1234"
        user.password_confirmation = "1234"
        expect(user).to be_invalid
        expect(user.errors[:password]).to eq [ "Passwordは5文字以上で入力してください" ]
      end

      it "パスワードが確認用と一致しない場合、エラーになる" do
        user.password = "12345"
        user.password_confirmation = "54321"
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to eq [ "Passwordと入力が一致しません" ]
      end

      it "パスワードが空の場合、エラーになる" do
        user.password = nil
        user.password_confirmation = nil
        expect(user).to be_invalid
        expect(user.errors[:password]).to eq [ "Passwordは5文字以上で入力してください" ]
      end
    end

    context "メールアドレス関連のバリデーション" do
      it "メールアドレスが空の場合、エラーになる" do
        user.email = nil
        expect(user).to be_invalid
        expect(user.errors[:email]).to eq [ "Emailを入力してください" ]
      end

      it "メールアドレスが重複する場合、エラーになる" do
        existing_user = create(:user, email: "duplicate@example.com")
        user.email = "duplicate@example.com"
        expect(user).to be_invalid
        expect(user.errors[:email]).to eq [ "そのEmailはすでに存在します" ]
      end
    end
  end
end
