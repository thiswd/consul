class CreateLegislationReviewSections < ActiveRecord::Migration[6.0]
  def change
    create_table :legislation_review_sections do |t|
      t.references :legislation_review, foreign_key: true
      t.bigint :review_section_section_type_id
      t.string :title
      t.text :description
      t.integer :section_votes_count, default: 0
      t.boolean :evaluable, default: false
      t.string :ancestry, index: true
      t.timestamps
    end

    add_foreign_key :legislation_review_sections,
      :legislation_review_section_types,
      column: :review_section_section_type_id
    add_index :legislation_review_sections,
      :review_section_section_type_id,
      name: "index_review_section_section_type_id"
  end
end
