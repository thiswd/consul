class AddReviewToLegislationProcesses < ActiveRecord::Migration[6.0]
  def change
    add_column :legislation_processes, :review_start_date, :date, index: true
    add_column :legislation_processes, :review_end_date, :date, index: true
    add_column :legislation_processes, :review_phase_enabled, :boolean, default: false
  end
end
