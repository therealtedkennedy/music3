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

ActiveRecord::Schema.define(:version => 20130113234417) do

  create_table "album_codes", :force => true do |t|
    t.string   "album_code"
    t.integer  "code_album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", :force => true do |t|
    t.string   "al_name"
    t.string   "al_type"
    t.string   "pri_artist"
    t.string   "contrib_artist"
    t.string   "al_copy_write"
    t.date     "al_rel_date"
    t.string   "pay_type"
    t.integer  "al_amount"
    t.string   "producer"
    t.string   "al_producer"
    t.string   "al_label"
    t.text     "liner_notes"
    t.integer  "downloads"
    t.integer  "plays"
    t.integer  "shares"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "al_a_id"
    t.integer  "al_s_id"
    t.string   "album_url_slug"
    t.string   "art"
    t.string   "description"
    t.string   "album_songs"
  end

  create_table "albums_artists", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "artist_id"
  end

  create_table "albums_songs", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "song_id"
  end

  create_table "albums_users", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "user_id"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.text     "influence"
    t.text     "bio"
    t.text     "contact_info"
    t.date     "date_founded"
    t.date     "created_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_slug"
    t.string   "pay_pal"
    t.string   "image"
    t.string   "twitter_name"
    t.string   "social_title"
    t.string   "fb_page_url"
    t.string   "logo"
  end

  create_table "artists_songs", :id => false, :force => true do |t|
    t.integer "artist_id"
    t.integer "song_id"
  end

  create_table "artists_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "artist_id"
  end

  create_table "layouts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.integer  "album_id"
  end

  create_table "profile_layouts", :force => true do |t|
    t.string   "h1_size"
    t.string   "h1_font"
    t.string   "h1_colour"
    t.string   "h2_size"
    t.string   "h2_font"
    t.string   "h2_colour"
    t.string   "h3_size"
    t.string   "h3_font"
    t.string   "h3_colour"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "artist_id"
    t.string   "p_size"
    t.string   "p_font"
    t.string   "p_colour"
    t.string   "div_1_colour"
    t.string   "div_1_transparency"
    t.string   "div_1_border_colour"
    t.string   "div_1_background_colour"
    t.string   "div_1_border_width"
    t.string   "div_2_colour"
    t.string   "div_2_transparency"
    t.string   "div_2_border_colour"
    t.string   "div_2_background_colour"
    t.string   "div_2_border_width"
    t.text     "profile_css"
    t.boolean  "use_css",                 :default => false
  end

  create_table "songs", :force => true do |t|
    t.string   "song_name"
    t.string   "song_artist"
    t.string   "song_contribute_artist"
    t.string   "song_written"
    t.string   "song_licence_type"
    t.string   "song_url_slug"
    t.date     "song_licence_date"
    t.integer  "song_plays"
    t.text     "lyrics"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "s3_name"
    t.string   "download_link"
    t.string   "torrent_link"
    t.string   "s3_id"
    t.integer  "s_a_id"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.text     "params",        :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pay_pal_email"
    t.string   "twitter_uid"
    t.string   "twitter_nickname"
    t.string   "twitter_name"
    t.string   "provider"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
