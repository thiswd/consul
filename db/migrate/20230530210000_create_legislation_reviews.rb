class CreateLegislationReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :legislation_reviews do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.references :legislation_process, foreign_key: true
      t.datetime :hidden_at
      t.timestamps null: false
    end
  end
end
