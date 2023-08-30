class Legislation::Review::SectionVote < ApplicationRecord
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :legislation_review_section_votes

  belongs_to :section,
    foreign_key: :review_section_id,
    class_name: "Legislation::Review::Section",
    inverse_of: :section_votes

  has_one :comment, as: :commentable, inverse_of: :commentable, dependent: :destroy
end
