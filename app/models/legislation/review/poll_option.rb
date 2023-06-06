class Legislation::Review::PollOption < ApplicationRecord
  belongs_to :section_type,
    class_name: "Legislation::Review::SectionType",
    foreign_key: "review_section_type_id",
    inverse_of: :poll_options

  validates :title, presence: true
  validates :title, length: { maximum: 30 }
end
