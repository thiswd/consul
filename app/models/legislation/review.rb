class Legislation::Review < ApplicationRecord
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  belongs_to :author, -> { with_hidden }, class_name: "User", inverse_of: :legislation_reviews
  belongs_to :process, foreign_key: "legislation_process_id", inverse_of: :reviews
end
