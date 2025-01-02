# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_12_19_172823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administrators", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_position", null: false
    t.index ["question_id", "sort_position"], name: "index_answers_on_question_id_and_sort_position", unique: true
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.string "parent_type", null: false
    t.integer "parent_id", null: false
    t.string "asset", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset"], name: "index_attachments_on_asset"
    t.index ["parent_id", "parent_type", "asset"], name: "index_attachments_on_parent_id_and_parent_type_and_asset", unique: true
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.integer "sort_position", null: false
    t.integer "publication_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id", "sort_position"], name: "index_authors_on_publication_id_and_sort_position", unique: true
    t.index ["user_id", "publication_id"], name: "index_authors_on_user_id_and_publication_id", unique: true
  end

  create_table "class_licenses", id: :serial, force: :cascade do |t|
    t.integer "sort_position", null: false
    t.integer "license_id", null: false
    t.string "class_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_name", "sort_position"], name: "index_class_licenses_on_class_name_and_sort_position", unique: true
    t.index ["license_id", "class_name"], name: "index_class_licenses_on_license_id_and_class_name", unique: true
  end

  create_table "collaborator_solutions", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "title"
    t.text "solution_type", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_collaborator_solutions_on_question_id"
    t.index ["solution_type"], name: "index_collaborator_solutions_on_solution_type"
    t.index ["title"], name: "index_collaborator_solutions_on_title"
  end

  create_table "combo_choice_answers", id: :serial, force: :cascade do |t|
    t.integer "combo_choice_id", null: false
    t.integer "answer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id", "combo_choice_id"], name: "index_combo_choice_answers_on_answer_id_and_combo_choice_id", unique: true
    t.index ["combo_choice_id"], name: "index_combo_choice_answers_on_combo_choice_id"
  end

  create_table "combo_choices", id: :serial, force: :cascade do |t|
    t.integer "stem_id", null: false
    t.decimal "correctness", precision: 3, scale: 2, default: "0.0", null: false
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stem_id", "correctness"], name: "index_combo_choices_on_stem_id_and_correctness"
  end

  create_table "community_solutions", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "title"
    t.text "solution_type", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_community_solutions_on_question_id"
    t.index ["solution_type"], name: "index_community_solutions_on_solution_type"
    t.index ["title"], name: "index_community_solutions_on_title"
  end

  create_table "copyright_holders", id: :serial, force: :cascade do |t|
    t.integer "sort_position", null: false
    t.integer "publication_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id", "sort_position"], name: "index_copyright_holders_on_publication_id_and_sort_position", unique: true
    t.index ["user_id", "publication_id"], name: "index_copyright_holders_on_user_id_and_publication_id", unique: true
  end

  create_table "delegations", id: :serial, force: :cascade do |t|
    t.integer "delegator_id", null: false
    t.string "delegate_type", null: false
    t.integer "delegate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_assign_authorship", null: false
    t.boolean "can_assign_copyright", null: false
    t.boolean "can_read", null: false
    t.boolean "can_update", null: false
    t.index ["delegate_id", "delegator_id", "delegate_type"], name: "index_delegations_on_delegate_delegator", unique: true
    t.index ["delegate_id", "delegator_id", "delegate_type"], name: "index_read_delegations_on_delegate_delegator", unique: true, where: "can_read"
    t.index ["delegate_id", "delegator_id", "delegate_type"], name: "index_update_delegations_on_delegate_delegator", unique: true, where: "can_update"
    t.index ["delegator_id"], name: "index_delegations_on_delegator_id"
  end

  create_table "derivations", id: :serial, force: :cascade do |t|
    t.integer "sort_position", null: false
    t.integer "derived_publication_id", null: false
    t.integer "source_publication_id"
    t.text "custom_attribution"
    t.datetime "hidden_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["derived_publication_id", "hidden_at"], name: "index_derivations_on_derived_publication_id_and_hidden_at"
    t.index ["derived_publication_id", "sort_position"], name: "index_derivations_on_derived_publication_id_and_sort_position", unique: true
    t.index ["source_publication_id", "derived_publication_id"], name: "index_derivations_on_source_p_id_and_derived_p_id", unique: true
  end

  create_table "exercise_tags", id: :serial, force: :cascade do |t|
    t.integer "exercise_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id", "tag_id"], name: "index_exercise_tags_on_exercise_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_exercise_tags_on_tag_id"
  end

  create_table "exercises", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "stimulus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vocab_term_id"
    t.string "a15k_identifier"
    t.integer "a15k_version"
    t.boolean "release_to_a15k"
    t.text "context"
    t.index ["title"], name: "index_exercises_on_title"
    t.index ["vocab_term_id"], name: "index_exercises_on_vocab_term_id"
  end

  create_table "fine_print_contracts", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "version"
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "version"], name: "index_fine_print_contracts_on_name_and_version", unique: true
  end

  create_table "fine_print_signatures", id: :serial, force: :cascade do |t|
    t.integer "contract_id", null: false
    t.string "user_type", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_implicit", default: false, null: false
    t.index ["contract_id"], name: "index_fine_print_signatures_on_contract_id"
    t.index ["user_id", "user_type", "contract_id"], name: "index_fine_print_signatures_on_u_id_and_u_type_and_c_id", unique: true
  end

  create_table "hints", id: :serial, force: :cascade do |t|
    t.integer "sort_position", null: false
    t.integer "question_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "sort_position"], name: "index_hints_on_question_id_and_sort_position", unique: true
  end

  create_table "license_compatibilities", id: :serial, force: :cascade do |t|
    t.integer "original_license_id", null: false
    t.integer "combined_license_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["combined_license_id", "original_license_id"], name: "index_license_compatibilities_on_c_l_id_and_o_l_id", unique: true
    t.index ["original_license_id"], name: "index_license_compatibilities_on_original_license_id"
  end

  create_table "licenses", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.text "publishing_contract", null: false
    t.text "copyright_notice", null: false
    t.boolean "requires_attribution", default: true, null: false
    t.boolean "requires_share_alike", default: false, null: false
    t.boolean "allows_derivatives", default: true, null: false
    t.boolean "allows_commercial_use", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_licenses_on_name", unique: true
    t.index ["title"], name: "index_licenses_on_title", unique: true
    t.index ["url"], name: "index_licenses_on_url", unique: true
  end

  create_table "list_editors", id: :serial, force: :cascade do |t|
    t.string "editor_type", null: false
    t.integer "editor_id", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["editor_id", "editor_type", "list_id"], name: "index_list_editors_on_editor_id_and_editor_type_and_list_id", unique: true
    t.index ["list_id"], name: "index_list_editors_on_list_id"
  end

  create_table "list_nestings", id: :serial, force: :cascade do |t|
    t.integer "parent_list_id", null: false
    t.integer "child_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_list_id"], name: "index_list_nestings_on_child_list_id", unique: true
    t.index ["parent_list_id"], name: "index_list_nestings_on_parent_list_id"
  end

  create_table "list_owners", id: :serial, force: :cascade do |t|
    t.string "owner_type", null: false
    t.integer "owner_id", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_list_owners_on_list_id"
    t.index ["owner_id", "owner_type", "list_id"], name: "index_list_owners_on_owner_id_and_owner_type_and_list_id", unique: true
  end

  create_table "list_publication_groups", id: :serial, force: :cascade do |t|
    t.integer "sort_position", null: false
    t.integer "list_id", null: false
    t.integer "publication_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id", "sort_position"], name: "index_list_publication_groups_on_list_id_and_sort_position", unique: true
    t.index ["publication_group_id", "list_id"], name: "index_list_publication_groups_on_p_g_id_and_l_id", unique: true
  end

  create_table "list_readers", id: :serial, force: :cascade do |t|
    t.string "reader_type", null: false
    t.integer "reader_id", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_list_readers_on_list_id"
    t.index ["reader_id", "reader_type", "list_id"], name: "index_list_readers_on_reader_id_and_reader_type_and_list_id", unique: true
  end

  create_table "lists", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_lists_on_name"
  end

  create_table "logic_variable_values", id: :serial, force: :cascade do |t|
    t.integer "logic_variable_id", null: false
    t.integer "seed", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logic_variable_id", "seed"], name: "index_logic_variable_values_on_logic_variable_id_and_seed", unique: true
  end

  create_table "logic_variables", id: :serial, force: :cascade do |t|
    t.integer "logic_id", null: false
    t.string "variable", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logic_id", "variable"], name: "index_logic_variables_on_logic_id_and_variable", unique: true
  end

  create_table "logics", id: :serial, force: :cascade do |t|
    t.string "parent_type", null: false
    t.integer "parent_id", null: false
    t.string "language", null: false
    t.text "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id", "parent_type", "language"], name: "index_logics_on_parent_id_and_parent_type_and_language", unique: true
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "owner_id"
    t.string "owner_type"
    t.boolean "confidential", default: true, null: false
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "openstax_accounts_accounts", id: :serial, force: :cascade do |t|
    t.integer "openstax_uid"
    t.string "username"
    t.string "access_token"
    t.string "first_name"
    t.string "last_name"
    t.string "full_name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faculty_status", default: 0, null: false
    t.string "salesforce_contact_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "role", default: 0, null: false
    t.citext "support_identifier"
    t.boolean "is_test"
    t.integer "school_type", default: 0, null: false
    t.boolean "is_kip"
    t.integer "school_location", default: 0, null: false
    t.boolean "grant_tutor_access"
    t.boolean "is_administrator"
    t.index ["access_token"], name: "index_openstax_accounts_accounts_on_access_token", unique: true
    t.index ["faculty_status"], name: "index_openstax_accounts_accounts_on_faculty_status"
    t.index ["first_name"], name: "index_openstax_accounts_accounts_on_first_name"
    t.index ["full_name"], name: "index_openstax_accounts_accounts_on_full_name"
    t.index ["last_name"], name: "index_openstax_accounts_accounts_on_last_name"
    t.index ["openstax_uid"], name: "index_openstax_accounts_accounts_on_openstax_uid"
    t.index ["role"], name: "index_openstax_accounts_accounts_on_role"
    t.index ["salesforce_contact_id"], name: "index_openstax_accounts_accounts_on_salesforce_contact_id"
    t.index ["school_type"], name: "index_openstax_accounts_accounts_on_school_type"
    t.index ["support_identifier"], name: "index_openstax_accounts_accounts_on_support_identifier", unique: true
    t.index ["username"], name: "index_openstax_accounts_accounts_on_username"
    t.index ["uuid"], name: "index_openstax_accounts_accounts_on_uuid", unique: true
  end

  create_table "publication_groups", id: :serial, force: :cascade do |t|
    t.string "publishable_type", null: false
    t.integer "number", null: false
    t.uuid "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "latest_version", null: false
    t.integer "latest_published_version"
    t.string "nickname"
    t.boolean "solutions_are_public", default: false, null: false
    t.index ["id", "latest_published_version"], name: "index_publication_groups_on_id_and_latest_published_version"
    t.index ["id", "latest_version"], name: "index_publication_groups_on_id_and_latest_version"
    t.index ["nickname"], name: "index_publication_groups_on_nickname", unique: true
    t.index ["number", "publishable_type"], name: "index_publication_groups_on_number_and_publishable_type", unique: true
    t.index ["publishable_type"], name: "index_publication_groups_on_publishable_type"
    t.index ["uuid"], name: "index_publication_groups_on_uuid", unique: true
  end

  create_table "publications", id: :serial, force: :cascade do |t|
    t.string "publishable_type", null: false
    t.integer "publishable_id", null: false
    t.integer "license_id"
    t.integer "version", null: false
    t.datetime "published_at"
    t.datetime "yanked_at"
    t.datetime "embargoed_until"
    t.boolean "embargo_children_only", default: false, null: false
    t.boolean "major_change", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "publication_group_id", null: false
    t.uuid "uuid", null: false
    t.index ["embargoed_until"], name: "index_publications_on_embargoed_until"
    t.index ["license_id"], name: "index_publications_on_license_id"
    t.index ["publication_group_id", "version"], name: "index_publications_on_publication_group_id_and_version"
    t.index ["publishable_id", "publishable_type"], name: "index_publications_on_publishable_id_and_publishable_type", unique: true
    t.index ["published_at"], name: "index_publications_on_published_at"
    t.index ["uuid"], name: "index_publications_on_uuid", unique: true
    t.index ["yanked_at"], name: "index_publications_on_yanked_at"
  end

  create_table "question_dependencies", id: :serial, force: :cascade do |t|
    t.integer "parent_question_id", null: false
    t.integer "dependent_question_id", null: false
    t.boolean "is_optional", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dependent_question_id", "parent_question_id"], name: "index_question_dependencies_on_dependent_q_id_and_parent_q_id", unique: true
    t.index ["parent_question_id"], name: "index_question_dependencies_on_parent_question_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "exercise_id", null: false
    t.text "stimulus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "answer_order_matters", default: false, null: false
    t.integer "sort_position", null: false
    t.index ["exercise_id", "sort_position"], name: "index_questions_on_exercise_id_and_sort_position", unique: true
  end

  create_table "stem_answers", id: :serial, force: :cascade do |t|
    t.integer "stem_id", null: false
    t.integer "answer_id", null: false
    t.decimal "correctness", precision: 3, scale: 2, default: "0.0", null: false
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id", "stem_id"], name: "index_stem_answers_on_answer_id_and_stem_id", unique: true
    t.index ["stem_id", "correctness"], name: "index_stem_answers_on_stem_id_and_correctness"
  end

  create_table "stems", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_stems_on_question_id"
  end

  create_table "stylings", id: :serial, force: :cascade do |t|
    t.string "stylable_type", null: false
    t.integer "stylable_id", null: false
    t.string "style", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stylable_id", "stylable_type", "style"], name: "index_stylings_on_stylable_id_and_stylable_type_and_style", unique: true
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "deleted_at"
    t.boolean "show_public_domain_attribution", default: true, null: false
    t.boolean "forward_notifications_to_deputies", default: false, null: false
    t.boolean "receive_role_notifications", default: true, null: false
    t.boolean "receive_access_notifications", default: true, null: false
    t.boolean "receive_comment_notifications", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
  end

  create_table "vocab_distractors", id: :serial, force: :cascade do |t|
    t.integer "vocab_term_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "distractor_publication_group_id", null: false
    t.index ["distractor_publication_group_id"], name: "index_vocab_distractors_on_distractor_publication_group_id"
    t.index ["vocab_term_id", "distractor_publication_group_id"], name: "index_vocab_distractors_on_v_t_id_and_d_p_g_id", unique: true
  end

  create_table "vocab_term_tags", id: :serial, force: :cascade do |t|
    t.integer "vocab_term_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_vocab_term_tags_on_tag_id"
    t.index ["vocab_term_id", "tag_id"], name: "index_vocab_term_tags_on_vocab_term_id_and_tag_id", unique: true
  end

  create_table "vocab_terms", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "definition", default: "", null: false
    t.string "distractor_literals", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["definition"], name: "index_vocab_terms_on_definition"
    t.index ["name", "definition"], name: "index_vocab_terms_on_name_and_definition"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "administrators", "users"
  add_foreign_key "answers", "questions"
  add_foreign_key "authors", "publications"
  add_foreign_key "authors", "users"
  add_foreign_key "class_licenses", "licenses"
  add_foreign_key "collaborator_solutions", "questions"
  add_foreign_key "combo_choice_answers", "answers"
  add_foreign_key "combo_choice_answers", "combo_choices"
  add_foreign_key "combo_choices", "stems"
  add_foreign_key "community_solutions", "questions"
  add_foreign_key "copyright_holders", "publications"
  add_foreign_key "copyright_holders", "users"
  add_foreign_key "delegations", "users", column: "delegator_id"
  add_foreign_key "derivations", "publications", column: "derived_publication_id"
  add_foreign_key "derivations", "publications", column: "source_publication_id"
  add_foreign_key "exercise_tags", "exercises"
  add_foreign_key "exercise_tags", "tags"
  add_foreign_key "exercises", "vocab_terms"
  add_foreign_key "hints", "questions"
  add_foreign_key "license_compatibilities", "licenses", column: "combined_license_id"
  add_foreign_key "license_compatibilities", "licenses", column: "original_license_id"
  add_foreign_key "list_editors", "lists"
  add_foreign_key "list_nestings", "lists", column: "child_list_id"
  add_foreign_key "list_nestings", "lists", column: "parent_list_id"
  add_foreign_key "list_owners", "lists"
  add_foreign_key "list_publication_groups", "lists"
  add_foreign_key "list_publication_groups", "publication_groups"
  add_foreign_key "list_readers", "lists"
  add_foreign_key "logic_variable_values", "logic_variables"
  add_foreign_key "logic_variables", "logics"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "publications", "licenses"
  add_foreign_key "publications", "publication_groups"
  add_foreign_key "question_dependencies", "questions", column: "dependent_question_id"
  add_foreign_key "question_dependencies", "questions", column: "parent_question_id"
  add_foreign_key "questions", "exercises"
  add_foreign_key "stem_answers", "answers"
  add_foreign_key "stem_answers", "stems"
  add_foreign_key "stems", "questions"
  add_foreign_key "users", "openstax_accounts_accounts", column: "account_id"
  add_foreign_key "vocab_distractors", "vocab_terms"
  add_foreign_key "vocab_term_tags", "tags"
  add_foreign_key "vocab_term_tags", "vocab_terms"
end
