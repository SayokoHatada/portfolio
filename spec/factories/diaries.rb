FactoryBot.define do
  factory :diary do
    title { "Sample Title" }
    body { "I am tester. I am Japan. I study English. I like reading a book and listening to music." }
    keyword { "Sample" }
    user
    corrected_body { nil }
    image_url { nil }
    start_time { nil }
  end
end
