FactoryBot.define do
  factory :question do
    stimulus { Faker::Lorem.paragraph }

    transient do
      stems_count { stems.empty? ? 1 : 0 }
      answers_count { answers.empty? ? 3 : 0 }
      collaborator_solutions_count { 1 }
    end

    after(:build) do |question, evaluator|
      question.exercise ||= build(:exercise, questions: [question])

      evaluator.stems_count.times do
        stem = build(:stem, question: question, stem_answers_count: 0)
        question.stems << stem

        evaluator.answers_count.times do
          answer = build(:answer, question: question)
          question.answers << answer
          stem_answer = build(:stem_answer, stem: stem, answer: answer)
          stem.stem_answers << stem_answer
          answer.stem_answers << stem_answer
        end

        evaluator.collaborator_solutions_count.times do
          solution = build(:collaborator_solution, question: question)
          question.collaborator_solutions << solution
        end

        stem.stem_answers.sample.correctness = 1.0 \
          if !stem.stem_answers.empty? && stem.stem_answers.none?{ |sa| sa.is_correct? }
      end
    end
  end
end
