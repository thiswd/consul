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

class CreateLegislationReviewPollVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :legislation_review_poll_votes do |t|
      t.bigint :review_poll_option_id
      t.references :user, foreign_key: true
      t.datetime :hidden_at
      t.timestamps
    end

    add_foreign_key :legislation_review_poll_votes,
      :legislation_review_polls,
      column: :review_poll_id
    add_index :legislation_review_poll_votes,
      :review_poll_id,
      name: "index_review_poll_vote_poll_id"
  end
end
