class CreateNewsArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :news_articles do |t|
      t.string :title
      t.text :body
      t.integer :status, default: 0, null: false
      t.datetime :published_at
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
