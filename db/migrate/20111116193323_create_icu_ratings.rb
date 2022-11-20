class CreateIcuRatings < ActiveRecord::Migration[4.2]
  def up
    create_table :icu_ratings do |t|
      # Warning: column order should match CSV import file.
      t.date     :list
      t.integer  :icu_id
      t.integer  :rating, limit: 2
      t.boolean  :full, default: false
    end

    # This is fast but it needs the column order to match and the DB user to have FILE privilege.
    execute "load data local infile '#{Rails.root}/db/data/icu_ratings.csv' into table icu_ratings fields terminated by ','"

    add_index :icu_ratings, :icu_id
    add_index :icu_ratings, :list
    add_index :icu_ratings, [:list, :icu_id], unique: true
  end

  def down
    drop_table :icu_ratings
  end
end
