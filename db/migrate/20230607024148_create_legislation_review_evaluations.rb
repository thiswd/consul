class CreateLegislationReviewEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :legislation_review_evaluations do |t|
      t.bigint :review_section_id
      t.bigint :review_poll_option_id
      t.string :title
      t.integer :section_votes_count, default: 0
      t.timestamps
    end

    add_foreign_key :legislation_review_evaluations,
      :legislation_review_sections,
      column: :review_section_id
    add_index :legislation_review_evaluations,
      :review_section_id,
      name: "index_review_evaluation_section_id"

    add_foreign_key :legislation_review_evaluations,
      :legislation_review_poll_options,
      column: :review_poll_option_id
    add_index :legislation_review_evaluations,
      :review_poll_option_id,
      name: "index_review_evaluation_poll_option_id"
  end
end
