class ChangeQuestionsAnswerOrderMattersDefaultToFalse < ActiveRecord::Migration
  def change
    change_column_default :questions, :answer_order_matters, false
  end
end
