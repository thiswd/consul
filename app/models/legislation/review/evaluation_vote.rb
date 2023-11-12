class Legislation::Review::EvaluationVote < ApplicationRecord
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :legislation_review_evaluation_votes

  belongs_to :evaluation,
    foreign_key: :review_evaluation_id,
    class_name: "Legislation::Review::Evaluation",
    inverse_of: :evaluation_votes

  has_one :comment, as: :commentable, inverse_of: :commentable, dependent: :destroy
end
