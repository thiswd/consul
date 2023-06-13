class Legislation::Review < ApplicationRecord
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  belongs_to :process,
    foreign_key: :legislation_process_id,
    inverse_of: :reviews

  belongs_to :author, -> { with_hidden },
    class_name: "User",
    inverse_of: :legislation_reviews

  has_many :section_types,
    foreign_key: :legislation_review_id,
    class_name: "Legislation::Review::SectionType",
    inverse_of: :review,
    dependent: :destroy

  has_many :sections,
    foreign_key: :legislation_review_id,
    class_name: "Legislation::Review::Section",
    inverse_of: :review,
    dependent: :destroy

  def root_sections
    sections.roots.order(:id)
  end

  def sections_votes_count
    sections.sum(&:section_votes_count)
  end
end
