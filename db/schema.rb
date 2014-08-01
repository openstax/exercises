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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140728232748) do

  create_table "administrators", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "administrators", ["user_id"], :name => "index_administrators_on_user_id", :unique => true

  create_table "answer_combos", :force => true do |t|
    t.integer  "answer_id",  :null => false
    t.integer  "combo_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "answer_combos", ["answer_id", "combo_id"], :name => "index_answer_combos_on_answer_id_and_combo_id", :unique => true
  add_index "answer_combos", ["combo_id"], :name => "index_answer_combos_on_combo_id"

  create_table "answers", :force => true do |t|
    t.integer  "position",                                                   :null => false
    t.integer  "question_id",                                                :null => false
    t.integer  "item_id"
    t.decimal  "correctness", :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.text     "content"
    t.string   "regex"
    t.float    "value"
    t.float    "tolerance"
    t.text     "feedback"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "answers", ["item_id"], :name => "index_answers_on_item_id"
  add_index "answers", ["question_id", "position"], :name => "index_answers_on_question_id_and_position", :unique => true

  create_table "author_requests", :force => true do |t|
    t.integer  "publishable_id",   :null => false
    t.string   "publishable_type", :null => false
    t.integer  "user_id",          :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "author_requests", ["publishable_id", "publishable_type", "user_id"], :name => "index_author_requests_on_p_id_and_p_type_and_u_id", :unique => true
  add_index "author_requests", ["user_id"], :name => "index_author_requests_on_user_id"

  create_table "authors", :force => true do |t|
    t.integer  "position",         :null => false
    t.integer  "publishable_id",   :null => false
    t.string   "publishable_type", :null => false
    t.integer  "user_id",          :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "authors", ["publishable_id", "publishable_type", "position"], :name => "index_authors_on_p_id_and_p_type_and_position", :unique => true
  add_index "authors", ["user_id", "publishable_id", "publishable_type"], :name => "index_authors_on_u_id_and_p_id_and_p_type", :unique => true

  create_table "combos", :force => true do |t|
    t.integer  "position",                                                   :null => false
    t.integer  "question_id",                                                :null => false
    t.decimal  "correctness", :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.text     "feedback"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "combos", ["question_id", "position"], :name => "index_combos_on_question_id_and_position", :unique => true

  create_table "commontator_comments", :force => true do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                        :null => false
    t.text     "body",                             :null => false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   :default => 0
    t.integer  "cached_votes_down", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "commontator_comments", ["cached_votes_down"], :name => "index_commontator_comments_on_cached_votes_down"
  add_index "commontator_comments", ["cached_votes_up"], :name => "index_commontator_comments_on_cached_votes_up"
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], :name => "index_commontator_comments_on_c_id_and_c_type_and_t_id"
  add_index "commontator_comments", ["thread_id"], :name => "index_commontator_comments_on_thread_id"

  create_table "commontator_subscriptions", :force => true do |t|
    t.string   "subscriber_type", :null => false
    t.integer  "subscriber_id",   :null => false
    t.integer  "thread_id",       :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], :name => "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", :unique => true
  add_index "commontator_subscriptions", ["thread_id"], :name => "index_commontator_subscriptions_on_thread_id"

  create_table "commontator_threads", :force => true do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], :name => "index_commontator_threads_on_c_id_and_c_type", :unique => true

  create_table "copyright_holder_requests", :force => true do |t|
    t.integer  "publishable_id",   :null => false
    t.string   "publishable_type", :null => false
    t.integer  "user_id",          :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "copyright_holder_requests", ["publishable_id", "publishable_type", "user_id"], :name => "index_copyright_holder_requests_on_p_id_and_p_type_and_u_id", :unique => true
  add_index "copyright_holder_requests", ["user_id"], :name => "index_copyright_holder_requests_on_user_id"

  create_table "copyright_holders", :force => true do |t|
    t.integer  "position",         :null => false
    t.integer  "publishable_id",   :null => false
    t.string   "publishable_type", :null => false
    t.integer  "user_id",          :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "copyright_holders", ["publishable_id", "publishable_type", "position"], :name => "index_copyright_holders_on_p_id_and_p_type_and_position", :unique => true
  add_index "copyright_holders", ["user_id", "publishable_id", "publishable_type"], :name => "index_copyright_holders_on_u_id_and_p_id_and_p_type", :unique => true

  create_table "derivations", :force => true do |t|
    t.integer  "position",               :null => false
    t.string   "publishable_type",       :null => false
    t.integer  "source_publishable_id",  :null => false
    t.integer  "derived_publishable_id", :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "derivations", ["publishable_type", "derived_publishable_id", "position"], :name => "index_derivations_on_p_type_and_d_p_id_and_position", :unique => true
  add_index "derivations", ["publishable_type", "source_publishable_id", "derived_publishable_id"], :name => "index_derivations_on_p_type_and_s_p_id_and_d_p_id", :unique => true

  create_table "exercises", :force => true do |t|
    t.integer  "number",                                    :null => false
    t.integer  "version",                :default => 1,     :null => false
    t.integer  "license_id",                                :null => false
    t.datetime "published_at"
    t.integer  "logic_id"
    t.string   "title"
    t.text     "background"
    t.datetime "embargoed_until"
    t.boolean  "embargo_solutions_only", :default => false, :null => false
    t.boolean  "changes_solutions",      :default => false, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "exercises", ["embargoed_until"], :name => "index_exercises_on_embargoed_until"
  add_index "exercises", ["license_id"], :name => "index_exercises_on_license_id"
  add_index "exercises", ["number", "version"], :name => "index_exercises_on_number_and_version", :unique => true
  add_index "exercises", ["published_at"], :name => "index_exercises_on_published_at"

  create_table "fine_print_contracts", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "version"
    t.string   "title",      :null => false
    t.text     "content",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "fine_print_contracts", ["name", "version"], :name => "index_fine_print_contracts_on_name_and_version", :unique => true

  create_table "fine_print_signatures", :force => true do |t|
    t.integer  "contract_id", :null => false
    t.integer  "user_id",     :null => false
    t.string   "user_type",   :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "fine_print_signatures", ["contract_id"], :name => "index_fine_print_signatures_on_contract_id"
  add_index "fine_print_signatures", ["user_id", "user_type", "contract_id"], :name => "index_fine_print_s_on_u_id_and_u_type_and_c_id", :unique => true

  create_table "format_solutions", :force => true do |t|
    t.integer  "format_id",   :null => false
    t.integer  "solution_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "format_solutions", ["format_id", "solution_id"], :name => "index_format_solutions_on_format_id_and_solution_id", :unique => true
  add_index "format_solutions", ["solution_id"], :name => "index_format_solutions_on_solution_id"

  create_table "formats", :force => true do |t|
    t.integer  "position",   :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "formats", ["name"], :name => "index_formats_on_name", :unique => true

  create_table "items", :force => true do |t|
    t.integer  "position",    :null => false
    t.integer  "question_id", :null => false
    t.text     "content",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "items", ["question_id", "position"], :name => "index_items_on_question_id_and_position", :unique => true

  create_table "libraries", :force => true do |t|
    t.integer  "owner_id"
    t.string   "language",                           :null => false
    t.string   "name",                               :null => false
    t.text     "summary"
    t.boolean  "is_prerequisite", :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "libraries", ["is_prerequisite"], :name => "index_libraries_on_is_prerequisite"
  add_index "libraries", ["language"], :name => "index_libraries_on_language"
  add_index "libraries", ["owner_id", "name"], :name => "index_libraries_on_owner_id_and_name", :unique => true

  create_table "library_versions", :force => true do |t|
    t.integer  "library_id",                    :null => false
    t.integer  "version",                       :null => false
    t.boolean  "deprecated", :default => false, :null => false
    t.text     "code",                          :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "library_versions", ["library_id", "deprecated"], :name => "index_library_versions_on_library_id_and_deprecated"
  add_index "library_versions", ["library_id", "version"], :name => "index_library_versions_on_library_id_and_version", :unique => true

  create_table "licenses", :force => true do |t|
    t.integer  "position",                                   :null => false
    t.string   "name",                                       :null => false
    t.string   "short_name",                                 :null => false
    t.string   "url",                                        :null => false
    t.string   "publishing_contract_name",                   :null => false
    t.boolean  "allows_exercises",         :default => true, :null => false
    t.boolean  "allows_solutions",         :default => true, :null => false
    t.boolean  "allows_rubrics",           :default => true, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "licenses", ["name"], :name => "index_licenses_on_name", :unique => true
  add_index "licenses", ["position"], :name => "index_licenses_on_position", :unique => true
  add_index "licenses", ["short_name"], :name => "index_licenses_on_short_name", :unique => true
  add_index "licenses", ["url"], :name => "index_licenses_on_url", :unique => true

  create_table "list_exercises", :force => true do |t|
    t.integer  "position",                                  :null => false
    t.integer  "list_id",                                   :null => false
    t.integer  "exercise_id",                               :null => false
    t.decimal  "credit",      :precision => 5, :scale => 2
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "list_exercises", ["exercise_id", "list_id"], :name => "index_list_exercises_on_exercise_id_and_list_id", :unique => true
  add_index "list_exercises", ["list_id", "position"], :name => "index_list_exercises_on_list_id_and_position", :unique => true

  create_table "lists", :force => true do |t|
    t.integer  "supergroup_id",                     :null => false
    t.integer  "parent_list_id"
    t.string   "name",                              :null => false
    t.boolean  "is_public",      :default => false, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "lists", ["parent_list_id"], :name => "index_lists_on_parent_list_id"
  add_index "lists", ["supergroup_id"], :name => "index_lists_on_supergroup_id", :unique => true

  create_table "logic_library_versions", :force => true do |t|
    t.integer  "logic_id",           :null => false
    t.integer  "library_version_id", :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "logic_library_versions", ["library_version_id"], :name => "index_logic_library_versions_on_library_version_id"
  add_index "logic_library_versions", ["logic_id", "library_version_id"], :name => "index_logic_library_versions_on_logic_id_and_library_version_id", :unique => true

  create_table "logic_outputs", :force => true do |t|
    t.integer  "logic_id",   :null => false
    t.integer  "seed",       :null => false
    t.text     "values",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "logic_outputs", ["logic_id", "seed"], :name => "index_logic_outputs_on_logic_id_and_seed", :unique => true

  create_table "logics", :force => true do |t|
    t.text     "code",       :null => false
    t.text     "variables",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",                            :null => false
    t.string   "uid",                             :null => false
    t.string   "secret",                          :null => false
    t.string   "redirect_uri",                    :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "trusted",      :default => false, :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], :name => "index_oauth_applications_on_owner_id_and_owner_type"
  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "openstax_accounts_accounts", :force => true do |t|
    t.integer  "openstax_uid", :null => false
    t.string   "username",     :null => false
    t.string   "access_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "title"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "openstax_accounts_accounts", ["access_token"], :name => "index_openstax_accounts_accounts_on_access_token", :unique => true
  add_index "openstax_accounts_accounts", ["first_name"], :name => "index_openstax_accounts_accounts_on_first_name"
  add_index "openstax_accounts_accounts", ["full_name"], :name => "index_openstax_accounts_accounts_on_full_name"
  add_index "openstax_accounts_accounts", ["last_name"], :name => "index_openstax_accounts_accounts_on_last_name"
  add_index "openstax_accounts_accounts", ["openstax_uid"], :name => "index_openstax_accounts_accounts_on_openstax_uid", :unique => true
  add_index "openstax_accounts_accounts", ["username"], :name => "index_openstax_accounts_accounts_on_username", :unique => true

  create_table "part_dependencies", :force => true do |t|
    t.integer  "position",          :null => false
    t.integer  "parent_part_id",    :null => false
    t.integer  "dependent_part_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "part_dependencies", ["dependent_part_id", "position"], :name => "index_part_dependencies_on_dependent_part_id_and_position", :unique => true
  add_index "part_dependencies", ["parent_part_id", "dependent_part_id"], :name => "index_part_dependencies_on_parent_part_id_and_dependent_part_id", :unique => true

  create_table "part_supports", :force => true do |t|
    t.integer  "position",           :null => false
    t.integer  "supporting_part_id", :null => false
    t.integer  "supported_part_id",  :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "part_supports", ["supported_part_id", "position"], :name => "index_part_supports_on_supported_part_id_and_position", :unique => true
  add_index "part_supports", ["supporting_part_id", "supported_part_id"], :name => "index_part_supports_on_supporting_part_id_and_supported_part_id", :unique => true

  create_table "parts", :force => true do |t|
    t.integer  "position",    :null => false
    t.integer  "exercise_id", :null => false
    t.text     "background"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "parts", ["exercise_id", "position"], :name => "index_parts_on_exercise_id_and_position", :unique => true

  create_table "question_formats", :force => true do |t|
    t.integer  "question_id", :null => false
    t.integer  "format_id",   :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "question_formats", ["format_id"], :name => "index_question_formats_on_format_id"
  add_index "question_formats", ["question_id", "format_id"], :name => "index_question_formats_on_question_id_and_format_id", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "position",   :null => false
    t.integer  "part_id",    :null => false
    t.text     "stem",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "questions", ["part_id", "position"], :name => "index_questions_on_part_id_and_position", :unique => true

  create_table "rubrics", :force => true do |t|
    t.integer  "number",                        :null => false
    t.integer  "version",        :default => 1, :null => false
    t.integer  "license_id",                    :null => false
    t.datetime "published_at"
    t.integer  "gradable_id",                   :null => false
    t.string   "gradable_type",                 :null => false
    t.text     "human_rubric"
    t.text     "machine_rubric"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "rubrics", ["gradable_id", "gradable_type"], :name => "index_rubrics_on_gradable_id_and_gradable_type", :unique => true

  create_table "solutions", :force => true do |t|
    t.integer  "number",                       :null => false
    t.integer  "version",      :default => 1,  :null => false
    t.integer  "license_id",                   :null => false
    t.datetime "published_at"
    t.integer  "question_id",                  :null => false
    t.text     "summary",      :default => "", :null => false
    t.text     "details",      :default => "", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "solutions", ["license_id"], :name => "index_solutions_on_license_id"
  add_index "solutions", ["number", "version"], :name => "index_solutions_on_number_and_version", :unique => true
  add_index "solutions", ["published_at"], :name => "index_solutions_on_published_at"
  add_index "solutions", ["question_id"], :name => "index_solutions_on_question_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "position",      :null => false
    t.integer  "uploader_id",   :null => false
    t.string   "uploader_type", :null => false
    t.string   "asset",         :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "uploads", ["asset"], :name => "index_uploads_on_asset", :unique => true
  add_index "uploads", ["uploader_id", "uploader_type", "position"], :name => "index_uploads_on_uploader_id_and_uploader_type_and_position", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "account_id",                                    :null => false
    t.integer  "default_list_id",                               :null => false
    t.datetime "registered_at"
    t.datetime "disabled_at"
    t.boolean  "subscribe_on_comment",       :default => false, :null => false
    t.boolean  "send_emails",                :default => true,  :null => false
    t.boolean  "collaborator_request_email", :default => true,  :null => false
    t.boolean  "permission_email",           :default => true,  :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id", :unique => true
  add_index "users", ["default_list_id"], :name => "index_users_on_default_list_id"
  add_index "users", ["disabled_at"], :name => "index_users_on_disabled_at"
  add_index "users", ["registered_at"], :name => "index_users_on_registered_at"

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
