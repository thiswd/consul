class Legislation::Review::SectionType < ApplicationRecord
  belongs_to :review,
    class_name: "Legislation::Review",
    foreign_key: "legislation_review_id",
    inverse_of: :section_types

  has_many :sections,
    class_name: "Legislation::Review::Section",
    foreign_key: "review_section_section_type_id",
    inverse_of: :section_type,
    dependent: :destroy

  has_many :poll_options,
    class_name: "Legislation::Review::PollOption",
    foreign_key: "review_section_type_id",
    inverse_of: :section_type,
    dependent: :destroy

  accepts_nested_attributes_for :poll_options,
    reject_if: proc { |attributes| attributes.all? { |_, v| v.blank? } },
    allow_destroy: true

  before_create :set_level

  delegate :section_types, to: :review
  delegate :process, to: :review

  validates :title, presence: true

  attr_accessor :show_poll_options_fields

  def section_type_label
    label = ""
    level.times { label << "1." }
    label
  end

  def downcase_title
    title.downcase
  end

  private

    def set_level
      self.level = next_level
    end

    def next_level
      section_types.count + 1
    end
end
