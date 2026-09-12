class CreateFavorites < ActiveRecord::Migration[8.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :news_article, null: false, foreign_key: true

      t.timestamps
    end
    add_index :favorites, [ :user_id, :news_article_id ], unique: true
  end
end
