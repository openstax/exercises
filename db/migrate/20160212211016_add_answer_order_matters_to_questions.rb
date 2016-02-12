class AddAnswerOrderMattersToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answer_order_matters, :boolean, null: false, default: true
  end
end
