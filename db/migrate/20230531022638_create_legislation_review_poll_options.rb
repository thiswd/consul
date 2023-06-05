class CreateLegislationReviewPollOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :legislation_review_poll_options do |t|
      t.string :title
      t.bigint :review_section_type_id
      t.timestamps
    end

    add_foreign_key :legislation_review_poll_options, :legislation_review_section_types,
column: :review_section_type_id
    add_index :legislation_review_poll_options, :review_section_type_id, name: "index_review_section_type_id"
  end
end
