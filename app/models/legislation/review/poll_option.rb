class Legislation::Review::PollOption < ApplicationRecord
  belongs_to :section_type,
    class_name: "Legislation::Review::SectionType",
    foreign_key: :review_section_type_id,
    inverse_of: :poll_options

  has_many :evaluations,
    foreign_key: :review_poll_option_id,
    inverse_of: :poll_option

  validates :title, presence: true
  validates :title, length: { maximum: 30 }

  before_update :update_evaluations, if: :title_changed?

  private

    delegate :process, to: :section_type

    def review_phase
      process.review_phase
    end

    def update_evaluations
      return if review_phase.open? || review_phase.closed?

      legislation_evaluations.update_all(title: title)
    end
end
