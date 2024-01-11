# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :publisher
      t.integer :published_year

      t.timestamps
    end
  end
end
