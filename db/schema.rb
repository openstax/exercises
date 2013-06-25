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

ActiveRecord::Schema.define(:version => 20130624174736) do

  create_table "announcements", :force => true do |t|
    t.integer  "creator_id"
    t.string   "subject"
    t.text     "body"
    t.boolean  "force"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "announcements", ["creator_id"], :name => "index_announcements_on_creator_id"

  create_table "assets", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_uploaded_at"
    t.integer  "uploader_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "assets", ["uploader_id"], :name => "index_assets_on_uploader_id"

  create_table "attachable_assets", :force => true do |t|
    t.integer  "attachable_id"
    t.integer  "asset_id"
    t.string   "local_name"
    t.text     "description"
    t.string   "attachable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "attachable_assets", ["attachable_id", "attachable_type", "local_name"], :name => "index_aa_on_a_id_and_a_type_and_l_name", :unique => true

  create_table "collaborator_requests", :force => true do |t|
    t.integer  "collaborator_id"
    t.integer  "requester_id"
    t.boolean  "toggle_author"
    t.boolean  "toggle_copyright_holder"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "collaborator_requests", ["collaborator_id", "toggle_author"], :name => "index_c_r_on_c_id_and_toggle_author", :unique => true
  add_index "collaborator_requests", ["collaborator_id", "toggle_copyright_holder"], :name => "index_c_r_on_c_id_and_toggle_copyright_holder", :unique => true

  create_table "collaborators", :force => true do |t|
    t.integer  "user_id"
    t.integer  "collaborable_id"
    t.string   "collaborable_type"
    t.integer  "number"
    t.boolean  "is_author"
    t.boolean  "is_copyright_holder"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "collaborators", ["collaborable_type", "collaborable_id", "number"], :name => "index_c_on_c_type_and_c_id_and_number", :unique => true
  add_index "collaborators", ["is_author"], :name => "index_collaborators_on_is_author"
  add_index "collaborators", ["is_copyright_holder"], :name => "index_collaborators_on_is_copyright_holder"
  add_index "collaborators", ["user_id", "collaborable_type", "collaborable_id"], :name => "index_c_on_u_id_and_c_type_and_c_id", :unique => true

  create_table "commontator_comments", :force => true do |t|
    t.text     "body"
    t.integer  "creator_id"
    t.string   "creator_type"
    t.datetime "deleted_at"
    t.integer  "deleter_id"
    t.string   "deleter_type"
    t.integer  "thread_id"
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
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.integer  "thread_id"
    t.integer  "unread",          :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], :name => "index_c_s_on_s_id_and_s_type_and_t_id", :unique => true
  add_index "commontator_subscriptions", ["thread_id"], :name => "index_commontator_subscriptions_on_thread_id"

  create_table "commontator_threads", :force => true do |t|
    t.integer  "commontable_id"
    t.string   "commontable_type"
    t.datetime "closed_at"
    t.integer  "closer_id"
    t.string   "closer_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], :name => "index_commontator_threads_on_commontable_id_and_commontable_type"

  create_table "deputizations", :force => true do |t|
    t.integer  "deputizer_id"
    t.integer  "deputy_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "deputizations", ["deputizer_id", "deputy_id"], :name => "index_deputizations_on_deputizer_id_and_deputy_id", :unique => true
  add_index "deputizations", ["deputy_id"], :name => "index_deputizations_on_deputy_id"

  create_table "exercise_derivations", :force => true do |t|
    t.integer  "derived_exercise_id"
    t.integer  "source_exercise_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "exercise_derivations", ["derived_exercise_id"], :name => "index_exercise_derivations_on_derived_exercise_id"
  add_index "exercise_derivations", ["source_exercise_id"], :name => "index_exercise_derivations_on_source_exercise_id"

  create_table "exercises", :force => true do |t|
    t.text     "content"
    t.text     "content_html"
    t.integer  "number"
    t.integer  "version"
    t.datetime "published_at"
    t.integer  "source_exercise_id"
    t.decimal  "suggested_credit"
    t.integer  "license_id"
    t.datetime "embargoed_until"
    t.boolean  "only_embargo_solutions"
    t.integer  "locked_by"
    t.datetime "locked_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "exercises", ["license_id"], :name => "index_exercises_on_license_id"
  add_index "exercises", ["number", "version"], :name => "index_exercises_on_number_and_version"
  add_index "exercises", ["published_at"], :name => "index_exercises_on_published_at"
  add_index "exercises", ["source_exercise_id"], :name => "index_exercises_on_source_exercise_id"

  create_table "fill_in_the_blank_answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "pre_content"
    t.text     "pre_content_html"
    t.text     "post_content"
    t.text     "post_content_html"
    t.string   "blank_answer"
    t.integer  "number"
    t.decimal  "credit"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "fill_in_the_blank_answers", ["question_id", "number"], :name => "index_fill_in_the_blank_answers_on_question_id_and_number", :unique => true

  create_table "free_response_answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.text     "content_html"
    t.text     "free_response"
    t.boolean  "can_be_sketched"
    t.integer  "number"
    t.decimal  "credit"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "free_response_answers", ["question_id", "number"], :name => "index_free_response_answers_on_question_id_and_number", :unique => true

  create_table "licenses", :force => true do |t|
    t.string   "short_name"
    t.string   "long_name"
    t.string   "url"
    t.string   "partial_name"
    t.boolean  "is_default"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "licenses", ["is_default"], :name => "index_licenses_on_is_default"

  create_table "list_exercises", :force => true do |t|
    t.integer  "list_id"
    t.integer  "exercise_id"
    t.integer  "number"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "list_exercises", ["exercise_id"], :name => "index_list_exercises_on_exercise_id"
  add_index "list_exercises", ["list_id", "exercise_id"], :name => "index_list_exercises_on_list_id_and_exercise_id", :unique => true
  add_index "list_exercises", ["list_id", "number"], :name => "index_list_exercises_on_list_id_and_number", :unique => true

  create_table "lists", :force => true do |t|
    t.string   "name"
    t.integer  "reader_user_group_id"
    t.integer  "editor_user_group_id"
    t.integer  "publisher_user_group_id"
    t.integer  "manager_user_group_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "matching_answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "content"
    t.string   "content_html"
    t.integer  "match_number"
    t.boolean  "right_column"
    t.integer  "number"
    t.decimal  "credit"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "matching_answers", ["question_id", "match_number", "right_column"], :name => "index_ma_on_q_id_and_m_number_and_right_column", :unique => true
  add_index "matching_answers", ["question_id", "number"], :name => "index_matching_answers_on_question_id_and_number", :unique => true

  create_table "multiple_choice_answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "content"
    t.string   "content_html"
    t.integer  "number"
    t.decimal  "credit"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "multiple_choice_answers", ["question_id", "number"], :name => "index_multiple_choice_answers_on_question_id_and_number", :unique => true

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

  create_table "question_dependency_pairs", :force => true do |t|
    t.integer  "independent_question_id"
    t.integer  "dependent_question_id"
    t.integer  "kind"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "question_dependency_pairs", ["dependent_question_id"], :name => "index_question_dependency_pairs_on_dependent_question_id"
  add_index "question_dependency_pairs", ["independent_question_id", "dependent_question_id", "kind"], :name => "index_qdp_on_iq_id_and_dq_id_and_kind", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "exercise_id"
    t.text     "content"
    t.text     "content_html"
    t.integer  "number"
    t.decimal  "credit"
    t.boolean  "changes_solution"
    t.integer  "source_question_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "questions", ["exercise_id", "number"], :name => "index_questions_on_exercise_id_and_number", :unique => true
  add_index "questions", ["source_question_id"], :name => "index_questions_on_source_question_id"

  create_table "short_answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.text     "content_html"
    t.string   "short_answer"
    t.integer  "number"
    t.decimal  "credit"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "short_answers", ["question_id", "number"], :name => "index_short_answers_on_question_id_and_number", :unique => true

  create_table "solutions", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.text     "content_html"
    t.text     "summary"
    t.integer  "number"
    t.integer  "version"
    t.datetime "published_at"
    t.integer  "source_solution_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "solutions", ["published_at"], :name => "index_solutions_on_published_at"
  add_index "solutions", ["question_id", "number", "version"], :name => "index_solutions_on_question_id_and_number_and_version", :unique => true
  add_index "solutions", ["source_solution_id"], :name => "index_solutions_on_source_solution_id"

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
    t.integer  "question_id"
    t.text     "content"
    t.text     "content_html"
    t.boolean  "is_true"
    t.integer  "number"
    t.decimal  "credit"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "true_or_false_answers", ["question_id", "number"], :name => "index_true_or_false_answers_on_question_id_and_number", :unique => true

  create_table "user_group_members", :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "user_id"
    t.boolean  "is_group_manager"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "user_group_members", ["user_group_id", "user_id"], :name => "index_user_group_members_on_user_group_id_and_user_id", :unique => true

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "default_list_id"
    t.boolean  "group_member_email"
    t.boolean  "collaborator_request_email"
    t.boolean  "announcement_email"
    t.boolean  "auto_author_subscribe"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "user_profiles", ["default_list_id"], :name => "index_user_profiles_on_default_list_id"
  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin",               :default => false
    t.datetime "disabled_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["disabled_at"], :name => "index_users_on_disabled_at"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["is_admin"], :name => "index_users_on_is_admin"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

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

  create_table "website_configurations", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "value_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "website_configurations", ["name"], :name => "index_website_configurations_on_name", :unique => true

end
