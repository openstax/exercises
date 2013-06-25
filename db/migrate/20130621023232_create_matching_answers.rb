class CreateMatchingAnswers < ActiveRecord::Migration
  def change
    create_table :matching_answers do |t|
      t.integer :question_id
      t.string :content
      t.string :content_html
      t.integer :match_number
      t.boolean :right_column
      t.integer :number
      t.decimal :credit

      t.timestamps
    end

    add_index :matching_answers, [:question_id, :number], :unique => true
    add_index :matching_answers, [:question_id, :match_number, :right_column], :unique => true, :name => "index_ma_on_q_id_and_m_number_and_right_column"
  end
end
