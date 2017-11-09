FactoryBot.define do
  factory :combo_choice_answer do
    combo_choice
    answer { build :answer, question: combo_choice.stem.question }
  end
end
