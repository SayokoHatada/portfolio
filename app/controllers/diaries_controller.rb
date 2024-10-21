class DiariesController < ApplicationController
  def index
    @diaries = Diary.all.includes(:user).order(created_at: :desc)
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
      redirect_to correct_diary_path(@diary)
    else
      render :new
    end
  end

  def correct
    @diary = Diary.find(params[:id])
  end

  def update
    @diary = Diary.find(params[:id])

    Rails.logger.debug("Params: #{params.inspect}")

    if @diary.update(diary_params)
      if params[:correct].present?
        english_text = @diary.body

        client = OpenAI::Client.new(access_token: Rails.application.credentials.openai[:api_key])

        begin
          response = client.chat(
            parameters: {
              model: "gpt-3.5-turbo",
              messages: [
                { role: "user", content: "以下の英語の文章を文法とスタイルのために修正してください:\n#{english_text}" }
              ],
              max_tokens: 150
            }
          )

          Rails.logger.debug("OpenAI response: #{response.inspect}")
          
          corrected_text = response.dig("choices", 0, "message", "content")&.strip

          if corrected_text.present?
            @diary.update(corrected_body: corrected_text)
            @corrected_text = corrected_text
          else
            handle_error_response("OpenAI APIから無効なレスポンスが返されました。")
          end
        rescue => e
          handle_error_response("添削に失敗しました: #{e.message}")
        end
      end

      redirect_to correct_diary_path(@diary)
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
    params.require(:diary).permit(:title, :body)
  end

  def handle_error_response(error_message)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("correction-result", partial: "diaries/error_message", locals: { error_message: error_message })
      end
      format.html { redirect_to @diary, alert: error_message }
    end
  end
end
