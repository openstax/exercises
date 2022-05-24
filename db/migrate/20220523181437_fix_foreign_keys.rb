class FixForeignKeys < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :exercise_tags, :exercises, on_update: :cascade, on_delete: :cascade
    remove_foreign_key :exercise_tags, :tags, on_update: :cascade, on_delete: :cascade
    remove_foreign_key :vocab_term_tags, :tags, on_update: :cascade, on_delete: :cascade
    remove_foreign_key :vocab_term_tags, :vocab_terms, on_update: :cascade, on_delete: :cascade

    reversible do |dir|
      dir.up do
        Answer.where.not(
          Question.where('"questions"."id" = "answers"."question_id"').arel.exists
        ).delete_all

        CollaboratorSolution.where.not(
          Question.where('"questions"."id" = "collaborator_solutions"."question_id"').arel.exists
        ).delete_all

        StemAnswer.where.not(
          Answer.where('"answers"."id" = "stem_answers"."answer_id"').arel.exists
        ).delete_all

        Stem.where.not(
          Question.where('"questions"."id" = "stems"."question_id"').arel.exists
        ).delete_all
      end
    end

    add_foreign_key :administrators, :users
    add_foreign_key :answers, :questions
    add_foreign_key :authors, :publications
    add_foreign_key :authors, :users
    add_foreign_key :class_licenses, :licenses
    add_foreign_key :collaborator_solutions, :questions
    add_foreign_key :combo_choice_answers, :combo_choices
    add_foreign_key :combo_choice_answers, :answers
    add_foreign_key :combo_choices, :stems
    add_foreign_key :community_solutions, :questions
    add_foreign_key :copyright_holders, :publications
    add_foreign_key :copyright_holders, :users
    add_foreign_key :delegations, :users, column: :delegator_id
    add_foreign_key :derivations, :publications, column: :derived_publication_id
    add_foreign_key :derivations, :publications, column: :source_publication_id
    add_foreign_key :exercise_tags, :exercises
    add_foreign_key :exercise_tags, :tags
    add_foreign_key :exercises, :vocab_terms
    add_foreign_key :hints, :questions
    add_foreign_key :license_compatibilities, :licenses, column: :combined_license_id
    add_foreign_key :license_compatibilities, :licenses, column: :original_license_id
    add_foreign_key :list_editors, :lists
    add_foreign_key :list_nestings, :lists, column: :child_list_id
    add_foreign_key :list_nestings, :lists, column: :parent_list_id
    add_foreign_key :list_owners, :lists
    add_foreign_key :list_readers, :lists
    add_foreign_key :logic_variable_values, :logic_variables
    add_foreign_key :logic_variables, :logics
    add_foreign_key :publications, :licenses
    add_foreign_key :publications, :publication_groups
    add_foreign_key :question_dependencies, :questions, column: :dependent_question_id
    add_foreign_key :question_dependencies, :questions, column: :parent_question_id
    add_foreign_key :questions, :exercises
    add_foreign_key :stem_answers, :answers
    add_foreign_key :stem_answers, :stems
    add_foreign_key :stems, :questions
    add_foreign_key :users, :openstax_accounts_accounts, column: :account_id
    add_foreign_key :vocab_distractors, :vocab_terms
    add_foreign_key :vocab_term_tags, :tags
    add_foreign_key :vocab_term_tags, :vocab_terms
  end
end
