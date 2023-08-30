class Legislation::Reviews::SectionVotesController < Legislation::BaseController
  before_action :authenticate_user!

  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :review, class: "Legislation::Review"
  load_and_authorize_resource class: "Legislation::Review::SectionVote"

  respond_to :js

  def create
    if @process.review_phase.open?
      @section_vote.user_id = current_user.id
      @section_vote.save!
      track_event
    end
  end

  def update
    if @process.review_phase.open?
      @section_vote.update!(section_vote_params)
    end
  end

  private

    def section_vote_params
      params.require(:legislation_review_section_vote).permit(
        :review_evaluation_id, :review_section_id
      )
    end

    def track_event
      ahoy.track :review_section_vote_created,
        review_section_vote_id: @section_vote.id,
        review_evaluation_id: @section_vote.review_evaluation_id,
        review_section_id: @section_vote.review_section_id
    end
end
