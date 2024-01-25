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

ActiveRecord::Schema[7.1].define(version: 2024_01_25_104129) do
  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "job_applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "qualification"
    t.string "skills"
    t.string "address"
    t.string "phone_no"
    t.string "experience"
    t.bigint "job_recruiter_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["job_recruiter_id"], name: "index_job_applications_on_job_recruiter_id"
  end

  create_table "job_applieds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "company_name"
    t.string "experience_required"
    t.string "salary"
    t.string "address"
    t.string "field"
    t.string "skills_required"
    t.bigint "job_seeker_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.bigint "job_application_id"
    t.index ["job_application_id"], name: "index_job_applieds_on_job_application_id"
    t.index ["job_id"], name: "index_job_applieds_on_job_id"
    t.index ["job_seeker_id"], name: "index_job_applieds_on_job_seeker_id"
  end

  create_table "job_recruiters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "Gst_no"
    t.string "address"
    t.string "phone_no"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_recruiters_on_user_id"
  end

  create_table "job_seekers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "qualification"
    t.string "skills"
    t.string "hobbies"
    t.string "address"
    t.string "phone_no"
    t.string "experience"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_field"
    t.index ["user_id"], name: "index_job_seekers_on_user_id"
  end

  create_table "jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "experience_required"
    t.string "salary"
    t.string "field"
    t.string "skills_required"
    t.bigint "job_recruiter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_recruiter_id"], name: "index_jobs_on_job_recruiter_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "description"
    t.string "image"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "job_applications", "job_recruiters"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applieds", "job_applications"
  add_foreign_key "job_applieds", "job_seekers"
  add_foreign_key "job_applieds", "jobs"
  add_foreign_key "job_recruiters", "users"
  add_foreign_key "job_seekers", "users"
  add_foreign_key "jobs", "job_recruiters"
  add_foreign_key "posts", "users"
end
