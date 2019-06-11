class AddDefaultToVocabTermsDefinition < ActiveRecord::Migration[4.2]
  def change
    change_column_default :vocab_terms, :definition, ''
  end
end
