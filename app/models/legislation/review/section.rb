class Legislation::Review::Section < ApplicationRecord
  has_ancestry

  belongs_to :review,
    class_name: "Legislation::Review",
    foreign_key: "legislation_review_id",
    inverse_of: :sections

  belongs_to :section_type,
    class_name: "Legislation::Review::SectionType",
    foreign_key: :review_section_section_type_id,
    inverse_of: :sections

  has_many :evaluations,
    class_name: "Legislation::Review::Evaluation",
    foreign_key: "review_section_id",
    inverse_of: :section,
    dependent: :destroy

  before_save :copy_evaluations, if: :evaluable

  def ordered_children
    children.order(:id)
  end

  private

    delegate :poll_options, to: :section_type

    def copy_evaluations
      return if evaluations.any?

      poll_options.each do |poll_option|
        evaluations.build(
          review_poll_option_id: poll_option.id,
          title: poll_option.title
        )
      end
    end
end
