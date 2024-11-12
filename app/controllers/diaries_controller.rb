class DiariesController < ApplicationController
  before_action :require_login
  before_action :set_diary, only: [ :show, :update, :destroy ]
  before_action :ensure_correct_user, only: [ :show, :update, :destroy ]

  def index
    @diaries = current_user.diaries.order(created_at: :desc)
  end

  def new
    @diary = Diary.new
  end

  def show
    @diary = Diary.find(params[:id])
  end

  def create
    @diary = current_user.diaries.build(diary_params)

    if @diary.save
      perform_correction_and_generate_image(@diary)

      redirect_to @diary
    else
      render :new
    end
  end

  def correct
    @diary = Diary.find(params[:id])
  end

  def update
    if @diary.update(diary_params)
      if params[:correct].present?
        perform_correction_and_generate_image(@diary)
      end
      redirect_to @diary
    else
      render :edit
    end
  end

  def destroy
    @diary = Diary.find(params[:id])

    if @diary.destroy
      redirect_to diaries_path, notice: "日記が削除されました。"
    else
      redirect_to diaries_path, alert: "日記の削除に失敗しました。"
    end
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :keyword).merge(user_id: current_user.id)
  end

  def perform_correction_and_generate_image(diary)
    correction_result = perform_correction(diary.body)
    if correction_result[:success]
      diary.update(corrected_body: correction_result[:corrected_text])
    end

    if diary.keyword.present?
      image_url = generate_image(diary.keyword)
      diary.update(image_url: image_url) if image_url
    end
  end

  def perform_correction(body)
    api_key = Rails.env.production? ? ENV["OPENAI_API_KEY"] : Rails.application.credentials.dig(:openai, :api_key)
    client = OpenAI::Client.new(access_token: api_key)

    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "user", content: "以下の英語の文章を文法とスタイルのために修正してください:\n#{body}" }
          ],
          max_tokens: 150
        }
      )

      Rails.logger.debug("OpenAI response: #{response.inspect}")

      corrected_text = response.dig("choices", 0, "message", "content")&.strip
      if corrected_text.present?
        { success: true, corrected_text: corrected_text }
      else
        { success: false, error_message: "OpenAI APIから無効なレスポンスが返されました。" }
      end
    rescue => e
      { success: false, error_message: "添削に失敗しました: #{e.message}" }
    end
  end

  def generate_image(keyword)
    api_key = Rails.env.production? ? ENV["OPENAI_API_KEY"] : Rails.application.credentials.dig(:openai, :api_key)
    client = OpenAI::Client.new(access_token: api_key)
    prompt = "#{keyword}, illustrated in a style similar to a children's diary drawing or a watercolor sketch, simple and warm, not realistic"

    begin
      response = client.images.generate(
        parameters: {
          prompt: prompt,
          n: 1,
          size: "1024x1024"
        }
      )

      image_url = response.dig("data", 0, "url")
      return image_url if image_url.present?
    rescue => e
      Rails.logger.error("画像生成エラー: #{e.message}")
    end
    nil
  end

  def set_diary
    @diary = Diary.find(params[:id])
  end

  def ensure_correct_user
    if @diary.nil? || @diary.user != current_user
      redirect_to diaries_path, alert: "アクセス権がありません。"
    end
  end
end
