class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string   :name
      t.integer  :time, limit: 2
      t.text     :report
      t.boolean  :success
      t.datetime :created_at
    end
  end
end
