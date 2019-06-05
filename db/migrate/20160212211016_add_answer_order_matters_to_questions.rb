class AddAnswerOrderMattersToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :answer_order_matters, :boolean, null: false, default: true
  end
end
