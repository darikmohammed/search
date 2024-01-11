class CreateSearchHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :search_histories do |t|
      t.string :search_string
      t.integer :number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
