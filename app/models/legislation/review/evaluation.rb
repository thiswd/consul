class Legislation::Review::Evaluation < ApplicationRecord
  belongs_to :section,
    class_name: "Legislation::Review::Section",
    foreign_key: "review_section_id",
    inverse_of: :evaluations

  belongs_to :poll_option,
    class_name: "Legislation::Review::PollOption",
    foreign_key: "review_poll_option_id",
    inverse_of: :evaluations

  validates :title, presence: true
end
