# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140822204013) do

  create_table "administrators", force: true do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "administrators", ["user_id"], name: "index_administrators_on_user_id", unique: true

  create_table "answers", force: true do |t|
    t.integer  "position",                                          null: false
    t.integer  "question_id",                                       null: false
    t.integer  "item_id"
    t.decimal  "correctness", precision: 3, scale: 2, default: 0.0, null: false
    t.text     "content"
    t.string   "regex"
    t.float    "value"
    t.float    "tolerance"
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["correctness"], name: "index_answers_on_correctness"
  add_index "answers", ["item_id"], name: "index_answers_on_item_id"
  add_index "answers", ["question_id", "position"], name: "index_answers_on_question_id_and_position", unique: true

  create_table "attachments", force: true do |t|
    t.integer  "attachable_id",   null: false
    t.string   "attachable_type", null: false
    t.string   "asset",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["asset"], name: "index_attachments_on_asset"
  add_index "attachments", ["attachable_id", "attachable_type", "asset"], name: "index_attachments_on_a_id_and_a_type_and_asset", unique: true

  create_table "author_requests", force: true do |t|
    t.integer  "requestor_id",    null: false
    t.integer  "collaborator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "author_requests", ["collaborator_id"], name: "index_author_requests_on_collaborator_id", unique: true
  add_index "author_requests", ["requestor_id"], name: "index_author_requests_on_requestor_id"

  create_table "collaborators", force: true do |t|
    t.integer  "position",                            null: false
    t.integer  "collaborable_id",                     null: false
    t.string   "collaborable_type",                   null: false
    t.integer  "user_id",                             null: false
    t.boolean  "is_author",           default: false, null: false
    t.boolean  "is_copyright_holder", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborators", ["collaborable_id", "collaborable_type", "position"], name: "index_collaborators_on_c_id_and_c_type_and_position", unique: true
  add_index "collaborators", ["user_id", "collaborable_id", "collaborable_type"], name: "index_collaborators_on_u_id_and_c_id_and_c_type", unique: true

  create_table "combo_choice_answers", force: true do |t|
    t.integer  "combo_choice_id", null: false
    t.integer  "answer_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "combo_choice_answers", ["answer_id", "combo_choice_id"], name: "index_combo_choice_answers_on_answer_id_and_combo_choice_id", unique: true
  add_index "combo_choice_answers", ["combo_choice_id"], name: "index_combo_choice_answers_on_combo_choice_id"

  create_table "combo_choices", force: true do |t|
    t.integer  "position",                                          null: false
    t.integer  "question_id",                                       null: false
    t.decimal  "correctness", precision: 3, scale: 2, default: 0.0, null: false
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "combo_choices", ["correctness"], name: "index_combo_choices_on_correctness"
  add_index "combo_choices", ["question_id", "position"], name: "index_combo_choices_on_question_id_and_position", unique: true

  create_table "commontator_comments", force: true do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down"
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up"
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id"
  add_index "commontator_comments", ["thread_id"], name: "index_commontator_comments_on_thread_id"

  create_table "commontator_subscriptions", force: true do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id"

  create_table "commontator_threads", force: true do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true

  create_table "copyright_holder_requests", force: true do |t|
    t.integer  "requestor_id",    null: false
    t.integer  "collaborator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "copyright_holder_requests", ["collaborator_id"], name: "index_copyright_holder_requests_on_collaborator_id", unique: true
  add_index "copyright_holder_requests", ["requestor_id"], name: "index_copyright_holder_requests_on_requestor_id"

  create_table "deputies", force: true do |t|
    t.integer  "deputizer_id", null: false
    t.integer  "deputy_id",    null: false
    t.string   "deputy_type",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deputies", ["deputizer_id"], name: "index_deputies_on_deputizer_id"
  add_index "deputies", ["deputy_id", "deputy_type", "deputizer_id"], name: "index_deputies_on_deputy_id_and_deputy_type_and_deputizer_id", unique: true

  create_table "derivations", force: true do |t|
    t.integer  "position",               null: false
    t.integer  "source_publication_id",  null: false
    t.integer  "derived_publication_id", null: false
    t.datetime "hidden_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "derivations", ["derived_publication_id", "position"], name: "index_derivations_on_derived_publication_id_and_position", unique: true
  add_index "derivations", ["source_publication_id", "derived_publication_id"], name: "index_derivations_on_source_p_id_and_derived_p_id", unique: true

  create_table "exercises", force: true do |t|
    t.text     "background",             default: "",    null: false
    t.string   "title"
    t.datetime "embargo_until"
    t.boolean  "only_embargo_solutions", default: false, null: false
    t.boolean  "changes_solutions",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exercises", ["embargo_until"], name: "index_exercises_on_embargo_until"

  create_table "fine_print_contracts", force: true do |t|
    t.string   "name",       null: false
    t.integer  "version"
    t.string   "title",      null: false
    t.text     "content",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fine_print_contracts", ["name", "version"], name: "index_fine_print_contracts_on_name_and_version", unique: true

  create_table "fine_print_signatures", force: true do |t|
    t.integer  "contract_id", null: false
    t.integer  "user_id",     null: false
    t.string   "user_type",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fine_print_signatures", ["contract_id"], name: "index_fine_print_signatures_on_contract_id"
  add_index "fine_print_signatures", ["user_id", "user_type", "contract_id"], name: "index_fine_print_signatures_on_u_id_and_u_type_and_c_id", unique: true

  create_table "formats", force: true do |t|
    t.integer  "position",   null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "formats", ["name"], name: "index_formats_on_name", unique: true

  create_table "grading_algorithms", force: true do |t|
    t.string   "name",         null: false
    t.string   "routine_name", null: false
    t.text     "description",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grading_algorithms", ["name"], name: "index_grading_algorithms_on_name", unique: true
  add_index "grading_algorithms", ["routine_name"], name: "index_grading_algorithms_on_routine_name", unique: true

  create_table "items", force: true do |t|
    t.integer  "position",    null: false
    t.integer  "question_id", null: false
    t.text     "content",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["question_id", "position"], name: "index_items_on_question_id_and_position", unique: true

  create_table "libraries", force: true do |t|
    t.integer  "owner_id"
    t.string   "name",                                   null: false
    t.string   "language",        default: "javascript", null: false
    t.boolean  "always_required", default: false,        null: false
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "libraries", ["language", "always_required"], name: "index_libraries_on_language_and_always_required"
  add_index "libraries", ["owner_id", "name"], name: "index_libraries_on_owner_id_and_name", unique: true

  create_table "library_versions", force: true do |t|
    t.integer  "library_id",    null: false
    t.integer  "version",       null: false
    t.datetime "deprecated_at"
    t.text     "code",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "library_versions", ["deprecated_at"], name: "index_library_versions_on_deprecated_at"
  add_index "library_versions", ["library_id", "version"], name: "index_library_versions_on_library_id_and_version", unique: true

  create_table "licenses", force: true do |t|
    t.integer  "position",                                 null: false
    t.string   "name",                                     null: false
    t.string   "short_name",                               null: false
    t.string   "url",                                      null: false
    t.text     "publishing_contract",                      null: false
    t.text     "copyright_notice",                         null: false
    t.text     "can_combine_into",    default: "--- []\n", null: false
    t.boolean  "allows_exercises",    default: true,       null: false
    t.boolean  "allows_solutions",    default: true,       null: false
    t.boolean  "allows_rubrics",      default: true,       null: false
    t.boolean  "is_public_domain",    default: false,      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "licenses", ["name"], name: "index_licenses_on_name", unique: true
  add_index "licenses", ["position"], name: "index_licenses_on_position", unique: true
  add_index "licenses", ["short_name"], name: "index_licenses_on_short_name", unique: true
  add_index "licenses", ["url"], name: "index_licenses_on_url", unique: true

  create_table "list_editors", force: true do |t|
    t.integer  "list_id"
    t.integer  "editor_id"
    t.string   "editor_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_editors", ["editor_id", "editor_type", "list_id"], name: "index_list_editors_on_editor_id_and_editor_type_and_list_id", unique: true
  add_index "list_editors", ["list_id"], name: "index_list_editors_on_list_id"

  create_table "list_exercises", force: true do |t|
    t.integer  "position",                            null: false
    t.integer  "list_id",                             null: false
    t.integer  "exercise_id",                         null: false
    t.decimal  "credit",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_exercises", ["credit"], name: "index_list_exercises_on_credit"
  add_index "list_exercises", ["exercise_id", "list_id"], name: "index_list_exercises_on_exercise_id_and_list_id", unique: true
  add_index "list_exercises", ["list_id", "position"], name: "index_list_exercises_on_list_id_and_position", unique: true

  create_table "list_owners", force: true do |t|
    t.integer  "list_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_owners", ["list_id"], name: "index_list_owners_on_list_id"
  add_index "list_owners", ["owner_id", "owner_type", "list_id"], name: "index_list_owners_on_owner_id_and_owner_type_and_list_id", unique: true

  create_table "list_readers", force: true do |t|
    t.integer  "list_id"
    t.integer  "reader_id"
    t.string   "reader_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_readers", ["list_id"], name: "index_list_readers_on_list_id"
  add_index "list_readers", ["reader_id", "reader_type", "list_id"], name: "index_list_readers_on_reader_id_and_reader_type_and_list_id", unique: true

  create_table "lists", force: true do |t|
    t.integer  "parent_list_id"
    t.string   "name",                           null: false
    t.boolean  "is_public",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["parent_list_id"], name: "index_lists_on_parent_list_id"

  create_table "logic_library_versions", force: true do |t|
    t.integer  "logic_id",           null: false
    t.integer  "library_version_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logic_library_versions", ["library_version_id"], name: "index_logic_library_versions_on_library_version_id"
  add_index "logic_library_versions", ["logic_id", "library_version_id"], name: "index_logic_library_versions_on_l_id_and_l_v_id", unique: true

  create_table "logic_outputs", force: true do |t|
    t.integer  "logic_id",   null: false
    t.integer  "seed",       null: false
    t.text     "values",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logic_outputs", ["logic_id", "seed"], name: "index_logic_outputs_on_logic_id_and_seed", unique: true

  create_table "logics", force: true do |t|
    t.integer  "logicable_id",   null: false
    t.string   "logicable_type", null: false
    t.text     "code",           null: false
    t.text     "variables",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logics", ["logicable_id", "logicable_type"], name: "index_logics_on_logicable_id_and_logicable_type", unique: true

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                         null: false
    t.string   "uid",                          null: false
    t.string   "secret",                       null: false
    t.text     "redirect_uri",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "trusted",      default: false, null: false
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "openstax_accounts_accounts", force: true do |t|
    t.integer  "openstax_uid", null: false
    t.string   "username",     null: false
    t.string   "access_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "openstax_accounts_accounts", ["access_token"], name: "index_openstax_accounts_accounts_on_access_token", unique: true
  add_index "openstax_accounts_accounts", ["first_name"], name: "index_openstax_accounts_accounts_on_first_name"
  add_index "openstax_accounts_accounts", ["full_name"], name: "index_openstax_accounts_accounts_on_full_name"
  add_index "openstax_accounts_accounts", ["last_name"], name: "index_openstax_accounts_accounts_on_last_name"
  add_index "openstax_accounts_accounts", ["openstax_uid"], name: "index_openstax_accounts_accounts_on_openstax_uid", unique: true
  add_index "openstax_accounts_accounts", ["username"], name: "index_openstax_accounts_accounts_on_username", unique: true

  create_table "part_dependencies", force: true do |t|
    t.integer  "position",          null: false
    t.integer  "parent_part_id",    null: false
    t.integer  "dependent_part_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_dependencies", ["dependent_part_id", "position"], name: "index_part_dependencies_on_dependent_part_id_and_position", unique: true
  add_index "part_dependencies", ["parent_part_id", "dependent_part_id"], name: "index_part_dependencies_on_p_p_id_and_d_p_id", unique: true

  create_table "part_supports", force: true do |t|
    t.integer  "position",           null: false
    t.integer  "supporting_part_id", null: false
    t.integer  "supported_part_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_supports", ["supported_part_id", "position"], name: "index_part_supports_on_supported_part_id_and_position", unique: true
  add_index "part_supports", ["supporting_part_id", "supported_part_id"], name: "index_part_supports_on_s_p_id_and_s_p_id", unique: true

  create_table "parts", force: true do |t|
    t.integer  "position",                 null: false
    t.integer  "exercise_id",              null: false
    t.text     "background",  default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["exercise_id", "position"], name: "index_parts_on_exercise_id_and_position", unique: true

  create_table "publications", force: true do |t|
    t.integer  "publishable_id",               null: false
    t.string   "publishable_type",             null: false
    t.integer  "license_id"
    t.integer  "number",                       null: false
    t.integer  "version",          default: 1, null: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["license_id"], name: "index_publications_on_license_id"
  add_index "publications", ["number", "publishable_type", "version"], name: "index_publications_on_number_and_publishable_type_and_version", unique: true
  add_index "publications", ["publishable_id", "publishable_type"], name: "index_publications_on_publishable_id_and_publishable_type", unique: true
  add_index "publications", ["published_at"], name: "index_publications_on_published_at"

  create_table "question_formats", force: true do |t|
    t.integer  "question_id", null: false
    t.integer  "format_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_formats", ["format_id"], name: "index_question_formats_on_format_id"
  add_index "question_formats", ["question_id", "format_id"], name: "index_question_formats_on_question_id_and_format_id", unique: true

  create_table "questions", force: true do |t|
    t.integer  "position",   null: false
    t.integer  "part_id",    null: false
    t.text     "stem",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["part_id", "position"], name: "index_questions_on_part_id_and_position", unique: true

  create_table "rubric_formats", force: true do |t|
    t.integer  "rubric_id",  null: false
    t.integer  "format_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rubric_formats", ["format_id"], name: "index_rubric_formats_on_format_id"
  add_index "rubric_formats", ["rubric_id", "format_id"], name: "index_rubric_formats_on_rubric_id_and_format_id", unique: true

  create_table "rubrics", force: true do |t|
    t.integer  "question_id",          null: false
    t.integer  "grading_algorithm_id"
    t.text     "human_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rubrics", ["grading_algorithm_id"], name: "index_rubrics_on_grading_algorithm_id"
  add_index "rubrics", ["question_id"], name: "index_rubrics_on_question_id"

  create_table "solution_formats", force: true do |t|
    t.integer  "solution_id", null: false
    t.integer  "format_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solution_formats", ["format_id"], name: "index_solution_formats_on_format_id"
  add_index "solution_formats", ["solution_id", "format_id"], name: "index_solution_formats_on_solution_id_and_format_id", unique: true

  create_table "solutions", force: true do |t|
    t.integer  "question_id", null: false
    t.text     "summary"
    t.text     "details",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solutions", ["question_id"], name: "index_solutions_on_question_id"

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: true do |t|
    t.integer  "account_id",                                     null: false
    t.boolean  "show_public_domain_attribution", default: true,  null: false
    t.boolean  "forward_emails_to_deputies",     default: false, null: false
    t.boolean  "receive_emails",                 default: true,  null: false
    t.boolean  "receive_collaborator_emails",    default: true,  null: false
    t.boolean  "receive_list_emails",            default: true,  null: false
    t.boolean  "receive_comment_emails",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", unique: true

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
