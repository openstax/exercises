class ChangeQuestionsAnswerOrderMattersDefaultToFalse < ActiveRecord::Migration[4.2]
  def change
    change_column_default :questions, :answer_order_matters, false
  end
end
