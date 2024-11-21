require "rails_helper"

RSpec.describe "Diaries", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:diary) { create(:diary) }

  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "日記の新規作成ページにアクセス" do
        it "新規作成ページへのアクセスが失敗する" do
          visit new_diary_path
          expect(page).to have_content("ログインが必要です")
          expect(current_path).to eq login_path
        end
      end

      context "日記の編集ページにアクセス" do
        it "編集ページへのアクセスが失敗する" do
          visit correct_diary_path(diary)
          expect(page).to have_content("ログインが必要です")
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe "ログイン後" do
    before do
      login_as(user)
      expect(page).to have_content("Login succeeded")
    end

    describe "日記新規作成" do
      context "フォームの入力値が正常" do
        it "日記の新規作成が成功する" do
          long_body = "a" * 50
          visit new_diary_path
          fill_in "Title", with: "test_title"
          fill_in "Your diary", with: long_body
          fill_in "keyword", with: "test, sample, system check"
          click_button "Create"
          expect(page).to have_text("test_title", wait:50)
          expect(page).to have_content long_body

          diary = Diary.last
          expect(current_path).to eq diary_path(diary)
        end
      end

      context "タイトルが未入力" do
        it "日記の新規作成が失敗する" do
          long_body = "a" * 50
          visit new_diary_path
          fill_in "diary_title", with: ""
          fill_in "diary_body", with: long_body
          click_button "Create"
          expect(current_path).to eq new_diary_path
        end
      end
    end

    describe "日記編集" do
      before do
        visit correct_diary_path(diary)
      end

      context "フォームの入力値が正常" do
        it "日記の編集が成功する" do
          fill_in "diary_title", with: "Updated Title"
          fill_in "diary_body", with: "hello. This is me. Life is strange. Strange things. Orange is the new black. good doctor"
          fill_in "diary_keyword", with: "Updated Keyword"
          click_button "correct-button"
          expect(current_path).to eq diary_path(diary)
        end
      end

      context "タイトルが未入力" do
        it "日記の編集が失敗する" do
          fill_in "diary_title", with: nil
          click_button "Update"
          expect(current_path).to eq correct_diary_path(diary)
        end
      end
    end

    describe "日記削除" do
      let!(:diary) { create(:diary, user: user) }

      it "日記の削除が成功する" do
        visit diary_path(diary)
        click_link "Delete"
        expect(page.accept_confirm).to eq "本当に削除しますか？"
        expect(page).to have_content "日記が削除されました"
        expect(current_path).to eq diaries_path
      end
    end
  end
end
