class CreateRatingLists < ActiveRecord::Migration[4.2]
  def up
    create_table :rating_lists do |t|
      t.date     :date, :cut_off
      t.datetime :created_at
    end
    add_index :rating_lists, :date
  end

  def down
    drop_table :rating_lists
  end
end

