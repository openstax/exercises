require 'rails_helper'

RSpec.describe FindInvalidExercises, type: :routine do
  let(:no_alt_text_img_content)      { Faker::Lorem.paragraph + '<img src="/example.jpg"/>' }
  let(:invalid_alt_text_img_content) do
    Faker::Lorem.paragraph + '<img src="/example.jpg"/ alt="Hello there">'
  end
  let(:valid_alt_text_img_content)   do
    Faker::Lorem.paragraph + '<img src="/example.jpg"/ alt="A nice plump alt text">'
  end

  let!(:no_img_exercises) { 5.times.map { FactoryBot.create :exercise } }

  let!(:no_alt_text_img_exercises) do
    [
      FactoryBot.create(:exercise, context: no_alt_text_img_content),
      FactoryBot.create(:exercise, stimulus: no_alt_text_img_content)
    ]
  end
  let!(:no_alt_text_img_question) { FactoryBot.create :question, stimulus: no_alt_text_img_content }
  let!(:no_alt_text_img_stem)     { FactoryBot.create :stem, content: no_alt_text_img_content }
  let!(:no_alt_text_img_answer)   { FactoryBot.create :answer, content: no_alt_text_img_content }

  let!(:invalid_alt_text_img_exercises) do
    [
      FactoryBot.create(:exercise, context: invalid_alt_text_img_content),
      FactoryBot.create(:exercise, stimulus: invalid_alt_text_img_content)
    ]
  end
  let!(:invalid_alt_text_img_question) do
    FactoryBot.create :question, stimulus: invalid_alt_text_img_content
  end
  let!(:invalid_alt_text_img_stem)     do
    FactoryBot.create :stem, content: invalid_alt_text_img_content
  end
  let!(:invalid_alt_text_img_answer)   do
    FactoryBot.create :answer, content: invalid_alt_text_img_content
  end

  let!(:valid_alt_text_img_exercises) do
    [
      FactoryBot.create(:exercise, context: valid_alt_text_img_content),
      FactoryBot.create(:exercise, stimulus: valid_alt_text_img_content)
    ]
  end
  let!(:valid_alt_text_img_question) do
    FactoryBot.create :question, stimulus: valid_alt_text_img_content
  end
  let!(:valid_alt_text_img_stem)     do
    FactoryBot.create :stem, content: valid_alt_text_img_content
  end
  let!(:valid_alt_text_img_answer)   do
    FactoryBot.create :answer, content: valid_alt_text_img_content
  end

  it 'finds all exercises with images missing alt text or with alt text that is too short' do
    expect(described_class[]).to eq(
      no_alt_text_img_exercises + [
        no_alt_text_img_question.exercise,
        no_alt_text_img_stem.question.exercise,
        no_alt_text_img_answer.question.exercise
      ] + invalid_alt_text_img_exercises + [
        invalid_alt_text_img_question.exercise,
        invalid_alt_text_img_stem.question.exercise,
        invalid_alt_text_img_answer.question.exercise
      ]
    )
  end
end
