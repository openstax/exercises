FactoryBot.define do
  factory :question_dependency do
    association :parent_question, factory: :question
    dependent_question { build :question, exercise: parent_question.exercise }
  end
end
