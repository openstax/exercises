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

ActiveRecord::Schema.define(:version => 20140128000437) do

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id",                   :null => false
    t.string   "attachable_type",                 :null => false
    t.integer  "number",                          :null => false
    t.string   "asset",           :default => "", :null => false
    t.string   "local_name",      :default => "", :null => false
    t.text     "caption",         :default => "", :null => false
    t.text     "alt",             :default => "", :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "attachments", ["attachable_type", "attachable_id", "local_name"], :name => "index_a_on_a_type_and_a_id_and_l_name", :unique => true
  add_index "attachments", ["attachable_type", "attachable_id", "number"], :name => "index_a_on_a_type_and_a_id_and_number", :unique => true
  add_index "attachments", ["attachable_type", "number"], :name => "index_attachments_on_attachable_type_and_number"

  create_table "collaborators", :force => true do |t|
    t.integer  "position",                                           :null => false
    t.integer  "publishable_id",                                     :null => false
    t.string   "publishable_type",                                   :null => false
    t.integer  "user_id",                                            :null => false
    t.boolean  "is_author",                       :default => false, :null => false
    t.boolean  "is_copyright_holder",             :default => false, :null => false
    t.boolean  "toggle_author_request",           :default => false, :null => false
    t.boolean  "toggle_copyright_holder_request", :default => false, :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "collaborators", ["publishable_type", "publishable_id", "position"], :name => "index_c_on_p_type_and_p_id_and_position", :unique => true
  add_index "collaborators", ["user_id", "publishable_type", "publishable_id"], :name => "index_c_on_u_id_and_p_type_and_p_id", :unique => true

  create_table "combo_choices", :force => true do |t|
    t.float    "credit"
    t.integer  "multiple_choice_question_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "combo_choices", ["multiple_choice_question_id"], :name => "index_combo_choices_on_multiple_choice_question_id"

  create_table "combo_simple_choices", :force => true do |t|
    t.integer  "combo_choice_id"
    t.integer  "simple_choice_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "combo_simple_choices", ["combo_choice_id", "simple_choice_id"], :name => "index_combo_simple_choices_cc_id_and_sc_id", :unique => true
  add_index "combo_simple_choices", ["combo_choice_id"], :name => "index_combo_simple_choices_on_combo_choice_id"
  add_index "combo_simple_choices", ["simple_choice_id"], :name => "index_combo_simple_choices_on_simple_choice_id"

  create_table "commontator_comments", :force => true do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                         :null => false
    t.text     "body",                              :null => false
    t.datetime "deleted_at"
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "commontator_comments", ["cached_votes_down"], :name => "index_commontator_comments_on_cached_votes_down"
  add_index "commontator_comments", ["cached_votes_total"], :name => "index_commontator_comments_on_cached_votes_total"
  add_index "commontator_comments", ["cached_votes_up"], :name => "index_commontator_comments_on_cached_votes_up"
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], :name => "index_c_c_on_c_id_and_c_type_and_t_id"
  add_index "commontator_comments", ["thread_id"], :name => "index_commontator_comments_on_thread_id"

  create_table "commontator_subscriptions", :force => true do |t|
    t.string   "subscriber_type",                :null => false
    t.integer  "subscriber_id",                  :null => false
    t.integer  "thread_id",                      :null => false
    t.integer  "unread",          :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], :name => "index_c_s_on_s_id_and_s_type_and_t_id", :unique => true
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

  add_index "commontator_threads", ["commontable_id", "commontable_type"], :name => "index_c_t_on_c_id_and_c_type", :unique => true

  create_table "contents", :force => true do |t|
    t.text     "markup"
    t.text     "html"
    t.integer  "attachable_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "contents", ["attachable_id"], :name => "index_contents_on_attachable_id"

  create_table "derivations", :force => true do |t|
    t.integer  "position",               :null => false
    t.string   "publishable_type",       :null => false
    t.integer  "source_publishable_id",  :null => false
    t.integer  "derived_publishable_id", :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "derivations", ["publishable_type", "derived_publishable_id", "position"], :name => "index_d_on_p_type_and_d_p_id_and_position", :unique => true
  add_index "derivations", ["publishable_type", "source_publishable_id", "derived_publishable_id"], :name => "index_d_on_p_type_and_s_p_id_and_d_p_id", :unique => true

  create_table "exercises", :force => true do |t|
    t.integer  "locker_id"
    t.datetime "locked_at"
    t.integer  "number",                                    :null => false
    t.integer  "version",                :default => 1,     :null => false
    t.integer  "license_id",                                :null => false
    t.datetime "published_at"
    t.integer  "embargo_days",           :default => 0,     :null => false
    t.date     "embargoed_until"
    t.boolean  "only_embargo_solutions", :default => false, :null => false
    t.boolean  "changes_solutions",      :default => false, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "background_id"
    t.string   "title"
    t.integer  "logic_id"
  end

  add_index "exercises", ["background_id"], :name => "index_exercises_on_background_id"
  add_index "exercises", ["license_id"], :name => "index_exercises_on_license_id"
  add_index "exercises", ["logic_id"], :name => "index_exercises_on_logic_id", :unique => true
  add_index "exercises", ["number", "version"], :name => "index_exercises_on_number_and_version", :unique => true
  add_index "exercises", ["published_at"], :name => "index_exercises_on_published_at"

  create_table "fill_in_the_blank_answers", :force => true do |t|
    t.text     "pre_content",       :default => "", :null => false
    t.text     "pre_content_html",  :default => "", :null => false
    t.text     "post_content",      :default => "", :null => false
    t.text     "post_content_html", :default => "", :null => false
    t.integer  "credit"
    t.integer  "position",                          :null => false
    t.integer  "question_id",                       :null => false
    t.string   "blank_answer",      :default => "", :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "fill_in_the_blank_answers", ["question_id", "position"], :name => "index_fill_in_the_blank_answers_on_question_id_and_position", :unique => true

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

  create_table "free_response_answers", :force => true do |t|
    t.text     "content",            :default => "",    :null => false
    t.text     "content_html",       :default => "",    :null => false
    t.text     "free_response",      :default => "",    :null => false
    t.text     "free_response_html", :default => "",    :null => false
    t.integer  "credit"
    t.integer  "position",                              :null => false
    t.integer  "question_id",                           :null => false
    t.boolean  "can_be_sketched",    :default => false, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "free_response_answers", ["question_id", "position"], :name => "index_free_response_answers_on_question_id_and_position", :unique => true

  create_table "libraries", :force => true do |t|
    t.integer  "language"
    t.string   "name"
    t.text     "summary"
    t.boolean  "is_prerequisite"
    t.integer  "owner_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "libraries", ["is_prerequisite"], :name => "index_libraries_on_is_prerequisite"
  add_index "libraries", ["language"], :name => "index_libraries_on_language"
  add_index "libraries", ["owner_id", "name"], :name => "index_libraries_on_owner_id_and_name", :unique => true
  add_index "libraries", ["owner_id"], :name => "index_libraries_on_owner_id"

  create_table "library_versions", :force => true do |t|
    t.integer  "library_id"
    t.text     "code"
    t.integer  "version"
    t.boolean  "deprecated"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "library_versions", ["library_id", "deprecated"], :name => "index_library_versions_on_library_id_and_deprecated"
  add_index "library_versions", ["library_id", "version"], :name => "index_library_versions_on_library_id_and_version", :unique => true
  add_index "library_versions", ["library_id"], :name => "index_library_versions_on_library_id"

  create_table "licenses", :force => true do |t|
    t.integer  "position",                                   :null => false
    t.string   "name",                     :default => "",   :null => false
    t.string   "short_name",               :default => "",   :null => false
    t.string   "url",                      :default => "",   :null => false
    t.boolean  "allow_exercises",          :default => true, :null => false
    t.boolean  "allow_solutions",          :default => true, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "publishing_contract_name"
  end

  add_index "licenses", ["name"], :name => "index_licenses_on_name", :unique => true
  add_index "licenses", ["position"], :name => "index_licenses_on_position", :unique => true
  add_index "licenses", ["short_name"], :name => "index_licenses_on_short_name", :unique => true
  add_index "licenses", ["url"], :name => "index_licenses_on_url", :unique => true

  create_table "list_exercises", :force => true do |t|
    t.integer  "position",    :null => false
    t.integer  "list_id",     :null => false
    t.integer  "exercise_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.float    "credit"
  end

  add_index "list_exercises", ["exercise_id", "list_id"], :name => "index_list_exercises_on_exercise_id_and_list_id", :unique => true
  add_index "list_exercises", ["list_id", "position"], :name => "index_list_exercises_on_list_id_and_position", :unique => true

  create_table "lists", :force => true do |t|
    t.integer  "parent_list_id"
    t.integer  "reader_user_group_id",                       :null => false
    t.integer  "editor_user_group_id",                       :null => false
    t.integer  "publisher_user_group_id",                    :null => false
    t.integer  "owner_user_group_id",                        :null => false
    t.string   "name",                    :default => "",    :null => false
    t.boolean  "is_public",               :default => false, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "lists", ["parent_list_id"], :name => "index_lists_on_parent_list_id"

  create_table "logic_outputs", :force => true do |t|
    t.integer  "seed"
    t.text     "values"
    t.integer  "logic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "logic_outputs", ["logic_id"], :name => "index_logic_outputs_on_logic_id"

  create_table "logics", :force => true do |t|
    t.text     "code"
    t.string   "variables"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "library_version_ids"
  end

  create_table "matching_answers", :force => true do |t|
    t.text     "left_content",       :default => "", :null => false
    t.text     "left_content_html",  :default => "", :null => false
    t.text     "right_content",      :default => "", :null => false
    t.text     "right_content_html", :default => "", :null => false
    t.integer  "credit"
    t.integer  "position",                           :null => false
    t.integer  "question_id",                        :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "matching_answers", ["question_id", "position"], :name => "index_matching_answers_on_question_id_and_position", :unique => true

  create_table "multiple_choice_answers", :force => true do |t|
    t.text     "content",        :default => "",    :null => false
    t.text     "content_html",   :default => "",    :null => false
    t.integer  "credit"
    t.integer  "position",                          :null => false
    t.integer  "question_id",                       :null => false
    t.boolean  "is_always_last", :default => false, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "multiple_choice_answers", ["question_id", "position"], :name => "index_multiple_choice_answers_on_question_id_and_position", :unique => true

  create_table "multiple_choice_questions", :force => true do |t|
    t.integer  "stem_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "multiple_choice_questions", ["stem_id"], :name => "index_multiple_choice_questions_on_stem_id"

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
    t.string   "name",         :null => false
    t.string   "uid",          :null => false
    t.string   "secret",       :null => false
    t.string   "redirect_uri", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "openstax_connect_users", :force => true do |t|
    t.integer  "openstax_uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "openstax_connect_users", ["openstax_uid"], :name => "index_openstax_connect_users_on_openstax_uid", :unique => true
  add_index "openstax_connect_users", ["username"], :name => "index_openstax_connect_users_on_username", :unique => true

  create_table "parts", :force => true do |t|
    t.integer  "exercise_id"
    t.integer  "background_id"
    t.integer  "position"
    t.float    "credit"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "parts", ["background_id"], :name => "index_parts_on_background_id"
  add_index "parts", ["exercise_id", "position"], :name => "index_parts_on_exercise_id_and_position", :unique => true
  add_index "parts", ["exercise_id"], :name => "index_parts_on_exercise_id"

  create_table "question_dependency_pairs", :force => true do |t|
    t.integer  "position",                :null => false
    t.integer  "dependent_question_id",   :null => false
    t.integer  "independent_question_id", :null => false
    t.integer  "kind",                    :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "question_dependency_pairs", ["dependent_question_id", "position"], :name => "index_qdp_on_dq_id_and_position", :unique => true
  add_index "question_dependency_pairs", ["independent_question_id", "dependent_question_id", "kind"], :name => "index_qdp_on_iq_id_and_dq_id_and_kind", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "position",                       :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "part_id"
    t.boolean  "is_default",  :default => false, :null => false
    t.string   "format_type", :default => "",    :null => false
    t.integer  "format_id",   :default => 0,     :null => false
  end

  add_index "questions", ["format_id", "format_type"], :name => "index_questions_on_format_id_and_format_type", :unique => true
  add_index "questions", ["is_default"], :name => "index_questions_on_is_default"
  add_index "questions", ["part_id", "position"], :name => "index_questions_on_part_id_and_position", :unique => true
  add_index "questions", ["part_id"], :name => "index_questions_on_part_id"

  create_table "short_answers", :force => true do |t|
    t.text     "content",      :default => "", :null => false
    t.text     "content_html", :default => "", :null => false
    t.integer  "credit"
    t.integer  "position",                     :null => false
    t.integer  "question_id",                  :null => false
    t.string   "short_answer", :default => "", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "short_answers", ["question_id", "position"], :name => "index_short_answers_on_question_id_and_position", :unique => true

  create_table "simple_choices", :force => true do |t|
    t.integer  "content_id"
    t.integer  "position"
    t.float    "credit"
    t.integer  "multiple_choice_question_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "simple_choices", ["content_id"], :name => "index_simple_choices_on_content_id"
  add_index "simple_choices", ["multiple_choice_question_id", "position"], :name => "index_simple_choices_on_multiple_choice_question_id_and_position", :unique => true
  add_index "simple_choices", ["multiple_choice_question_id"], :name => "index_simple_choices_on_multiple_choice_question_id"

  create_table "solutions", :force => true do |t|
    t.integer  "number",                      :null => false
    t.integer  "version",      :default => 1, :null => false
    t.integer  "license_id",                  :null => false
    t.datetime "published_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "part_id"
    t.integer  "details_id"
    t.integer  "summary_id"
    t.integer  "logic_id"
  end

  add_index "solutions", ["details_id"], :name => "index_solutions_on_details_id"
  add_index "solutions", ["license_id"], :name => "index_solutions_on_license_id"
  add_index "solutions", ["logic_id"], :name => "index_solutions_on_logic_id", :unique => true
  add_index "solutions", ["number", "version"], :name => "index_solutions_on_number_and_version", :unique => true
  add_index "solutions", ["part_id"], :name => "index_solutions_on_part_id"
  add_index "solutions", ["published_at"], :name => "index_solutions_on_published_at"
  add_index "solutions", ["summary_id"], :name => "index_solutions_on_summary_id"

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

  create_table "true_or_false_answers", :force => true do |t|
    t.text     "content",      :default => "",    :null => false
    t.text     "content_html", :default => "",    :null => false
    t.integer  "credit"
    t.integer  "position",                        :null => false
    t.integer  "question_id",                     :null => false
    t.boolean  "is_true",      :default => false, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "true_or_false_answers", ["question_id", "position"], :name => "index_true_or_false_answers_on_question_id_and_position", :unique => true

  create_table "user_group_users", :force => true do |t|
    t.integer  "position",                         :null => false
    t.integer  "user_group_id",                    :null => false
    t.integer  "user_id",                          :null => false
    t.boolean  "is_manager",    :default => false, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "user_group_users", ["user_group_id", "user_id"], :name => "index_user_group_users_on_user_group_id_and_user_id", :unique => true
  add_index "user_group_users", ["user_id", "position"], :name => "index_user_group_users_on_user_id_and_position", :unique => true

  create_table "user_groups", :force => true do |t|
    t.integer  "container_id"
    t.string   "container_type"
    t.string   "name",           :default => "", :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "user_groups", ["container_type", "container_id"], :name => "index_user_groups_on_container_type_and_container_id"

  create_table "users", :force => true do |t|
    t.boolean  "is_registered"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "is_admin",                   :default => false, :null => false
    t.datetime "disabled_at"
    t.integer  "openstax_connect_user_id"
    t.integer  "default_list_id",                               :null => false
    t.boolean  "auto_author_subscribe",      :default => false, :null => false
    t.boolean  "collaborator_request_email", :default => false, :null => false
    t.boolean  "user_group_member_email",    :default => false, :null => false
  end

  add_index "users", ["default_list_id"], :name => "index_users_on_default_list_id"
  add_index "users", ["disabled_at"], :name => "index_users_on_disabled_at"
  add_index "users", ["is_admin"], :name => "index_users_on_is_admin"
  add_index "users", ["openstax_connect_user_id"], :name => "index_users_on_openstax_connect_user_id", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
