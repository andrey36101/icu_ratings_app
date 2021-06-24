class CreateLogins < ActiveRecord::Migration[4.2]
  def change
    create_table :logins do |t|
      t.integer  :user_id
      t.string   :ip, limit: 39
      t.string   :problem, limit: 8, default: "none"
      t.string   :role, limit: 20
      t.datetime :created_at
    end
  end
end
