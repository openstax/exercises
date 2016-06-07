class AddDefaultToVocabTermsDefinition < ActiveRecord::Migration
  def change
    change_column_default :vocab_terms, :definition, ''
  end
end
