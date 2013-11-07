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

ActiveRecord::Schema.define(:version => 20131031201230) do

  create_table "attachments", :force => true do |t|
    t.integer  "number",                          :null => false
    t.string   "attachable_type",                 :null => false
    t.integer  "attachable_id",                   :null => false
    t.string   "asset",           :default => "", :null => false
    t.string   "local_name",      :default => "", :null => false
    t.text     "caption",         :default => "", :null => false
    t.text     "alt",             :default => "", :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "attachments", ["attachable_type", "attachable_id", "local_name"], :name => "index_a_on_a_type_and_a_id_and_l_name", :unique => true
  add_index "attachments", ["attachable_type", "number"], :name => "index_attachments_on_attachable_type_and_number", :unique => true

  create_table "collaborators", :force => true do |t|
    t.integer  "position",                                           :null => false
    t.string   "publishable_type",                                   :null => false
    t.integer  "publishable_id",                                     :null => false
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

  create_table "commontator_comments", :force => true do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                          :null => false
    t.text     "body",               :default => "", :null => false
    t.datetime "deleted_at"
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "commontator_comments", ["cached_votes_down"], :name => "index_commontator_comments_on_cached_votes_down"
  add_index "commontator_comments", ["cached_votes_total"], :name => "index_commontator_comments_on_cached_votes_total"
  add_index "commontator_comments", ["cached_votes_up"], :name => "index_commontator_comments_on_cached_votes_up"
  add_index "commontator_comments", ["creator_type", "creator_id", "thread_id"], :name => "index_c_c_on_c_type_and_c_id_and_t_id"
  add_index "commontator_comments", ["thread_id"], :name => "index_commontator_comments_on_thread_id"

  create_table "commontator_subscriptions", :force => true do |t|
    t.string   "subscriber_type",                :null => false
    t.integer  "subscriber_id",                  :null => false
    t.integer  "thread_id",                      :null => false
    t.integer  "unread",          :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "commontator_subscriptions", ["subscriber_type", "subscriber_id", "thread_id"], :name => "index_c_s_on_s_type_and_s_id_and_t_id", :unique => true
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

  add_index "commontator_threads", ["commontable_type", "commontable_id"], :name => "index_commontator_threads_on_commontable_type_and_commontable_id", :unique => true

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
    t.text     "content",                :default => "",    :null => false
    t.text     "content_html",           :default => "",    :null => false
    t.integer  "number",                                    :null => false
    t.integer  "version",                :default => 1,     :null => false
    t.datetime "published_at"
    t.integer  "license_id",                                :null => false
    t.integer  "credit"
    t.integer  "embargo_days",           :default => 0,     :null => false
    t.date     "embargoed_until"
    t.boolean  "only_embargo_solutions", :default => false, :null => false
    t.integer  "locked_by"
    t.datetime "locked_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "exercises", ["license_id"], :name => "index_exercises_on_license_id"
  add_index "exercises", ["number", "version"], :name => "index_exercises_on_number_and_version", :unique => true
  add_index "exercises", ["published_at"], :name => "index_exercises_on_published_at"

  create_table "fill_in_the_blank_answers", :force => true do |t|
    t.text     "pre_content",       :default => "", :null => false
    t.text     "pre_content_html",  :default => "", :null => false
    t.text     "post_content",      :default => "", :null => false
    t.text     "post_content_html", :default => "", :null => false
    t.integer  "position",                          :null => false
    t.integer  "question_id",                       :null => false
    t.string   "blank_answer",      :default => "", :null => false
    t.integer  "credit"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "fill_in_the_blank_answers", ["question_id", "position"], :name => "index_fill_in_the_blank_answers_on_question_id_and_position", :unique => true

  create_table "fine_print_contracts", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "version"
    t.string   "title",                         :null => false
    t.text     "content",                       :null => false
    t.boolean  "is_latest",  :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "fine_print_contracts", ["name", "is_latest"], :name => "index_fine_print_contracts_on_name_and_is_latest"
  add_index "fine_print_contracts", ["name"], :name => "index_fine_print_contracts_on_name"

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
    t.integer  "position",                              :null => false
    t.integer  "question_id",                           :null => false
    t.text     "free_response",      :default => "",    :null => false
    t.text     "free_response_html", :default => "",    :null => false
    t.boolean  "can_be_sketched",    :default => false, :null => false
    t.integer  "credit"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "free_response_answers", ["question_id", "position"], :name => "index_free_response_answers_on_question_id_and_position", :unique => true

  create_table "licenses", :force => true do |t|
    t.integer  "position",                           :null => false
    t.string   "name",             :default => "",   :null => false
    t.string   "short_name",       :default => "",   :null => false
    t.string   "url",              :default => "",   :null => false
    t.string   "partial_filename", :default => "",   :null => false
    t.boolean  "allow_exercises",  :default => true, :null => false
    t.boolean  "allow_solutions",  :default => true, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
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

  create_table "matching_answers", :force => true do |t|
    t.string   "left_content",       :default => "", :null => false
    t.string   "left_content_html",  :default => "", :null => false
    t.string   "right_content",      :default => "", :null => false
    t.string   "right_content_html", :default => "", :null => false
    t.integer  "position",                           :null => false
    t.integer  "question_id",                        :null => false
    t.integer  "credit"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "matching_answers", ["question_id", "position"], :name => "index_matching_answers_on_question_id_and_position", :unique => true

  create_table "multiple_choice_answers", :force => true do |t|
    t.string   "content",        :default => "",    :null => false
    t.string   "content_html",   :default => "",    :null => false
    t.integer  "position",                          :null => false
    t.integer  "question_id",                       :null => false
    t.boolean  "is_always_last", :default => false, :null => false
    t.integer  "credit"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "multiple_choice_answers", ["question_id", "position"], :name => "index_multiple_choice_answers_on_question_id_and_position", :unique => true

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
    t.text     "content",          :default => "",    :null => false
    t.text     "content_html",     :default => "",    :null => false
    t.integer  "position",                            :null => false
    t.integer  "exercise_id",                         :null => false
    t.boolean  "changes_solution", :default => false, :null => false
    t.integer  "credit"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "questions", ["exercise_id", "position"], :name => "index_questions_on_exercise_id_and_position", :unique => true

  create_table "short_answers", :force => true do |t|
    t.text     "content",      :default => "", :null => false
    t.text     "content_html", :default => "", :null => false
    t.integer  "position",                     :null => false
    t.integer  "question_id",                  :null => false
    t.string   "short_answer", :default => "", :null => false
    t.integer  "credit"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "short_answers", ["question_id", "position"], :name => "index_short_answers_on_question_id_and_position", :unique => true

  create_table "solutions", :force => true do |t|
    t.integer  "exercise_id",                  :null => false
    t.text     "summary",      :default => "", :null => false
    t.text     "content",      :default => "", :null => false
    t.text     "content_html", :default => "", :null => false
    t.integer  "number",                       :null => false
    t.integer  "version",      :default => 1,  :null => false
    t.datetime "published_at"
    t.integer  "license_id",                   :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "solutions", ["exercise_id", "number", "version"], :name => "index_solutions_on_exercise_id_and_number_and_version", :unique => true
  add_index "solutions", ["license_id"], :name => "index_solutions_on_license_id"
  add_index "solutions", ["published_at"], :name => "index_solutions_on_published_at"

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
    t.integer  "position",                        :null => false
    t.integer  "question_id",                     :null => false
    t.boolean  "is_true",      :default => false, :null => false
    t.integer  "credit"
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

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id",                                       :null => false
    t.integer  "default_list_id",                               :null => false
    t.boolean  "auto_author_subscribe",      :default => false, :null => false
    t.boolean  "announcement_email",         :default => false, :null => false
    t.boolean  "collaborator_request_email", :default => false, :null => false
    t.boolean  "user_group_member_email",    :default => false, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "user_profiles", ["default_list_id"], :name => "index_user_profiles_on_default_list_id"
  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.boolean  "is_registered"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "is_admin",                 :default => false, :null => false
    t.datetime "disabled_at"
    t.integer  "openstax_connect_user_id"
  end

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
