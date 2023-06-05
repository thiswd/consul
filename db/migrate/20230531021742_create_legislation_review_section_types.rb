class CreateLegislationReviewSectionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :legislation_review_section_types do |t|
      t.string :title
      t.integer :level
      t.references :legislation_review, foreign_key: true
      t.timestamps
    end
  end
end
