class Legislation::ProcessesController < Legislation::BaseController
  include RandomSeed

  has_filters %w[open past], only: :index
  has_filters %w[random winners], only: :proposals

  load_and_authorize_resource

  before_action :set_random_seed, only: :proposals
  before_action :set_process, only: [
    :debate,
    :draft_publication,
    :allegations,
    :result_publication,
    :proposals,
    :review
  ]

  def index
    @current_filter ||= "open"
    @processes = ::Legislation::Process.send(@current_filter).published
                 .not_in_draft.order(start_date: :desc).page(params[:page])
  end

  def show
    draft_version = @process.draft_versions.published.last
    allegations_phase = @process.allegations_phase

    if @process.homepage_enabled? && @process.homepage.present?
      render :show
    elsif allegations_phase.enabled? && allegations_phase.started? && draft_version.present?
      redirect_to legislation_process_draft_version_path(@process, draft_version)
    elsif @process.debate_phase.enabled?
      redirect_to debate_legislation_process_path(@process)
    elsif @process.proposals_phase.enabled?
      redirect_to proposals_legislation_process_path(@process)
    elsif @process.review_phase.enabled?
      redirect_to reviews_legislation_process_path(@process)
    else
      redirect_to allegations_legislation_process_path(@process)
    end
  end

  def debate
    @phase = :debate_phase

    if @process.debate_phase.started? || current_user&.administrator?
      render :debate
    else
      render :phase_not_open
    end
  end

  def draft_publication
    @phase = :draft_publication

    if @process.draft_publication.started?
      draft_version = @process.draft_versions.published.last

      if draft_version.present?
        redirect_to legislation_process_draft_version_path(@process, draft_version)
      else
        render :phase_empty
      end
    else
      render :phase_not_open
    end
  end

  def allegations
    @phase = :allegations_phase

    if @process.allegations_phase.started?
      draft_version = @process.draft_versions.published.last

      if draft_version.present?
        redirect_to legislation_process_draft_version_path(@process, draft_version)
      else
        render :phase_empty
      end
    else
      render :phase_not_open
    end
  end

  def result_publication
    @phase = :result_publication

    if @process.result_publication.started?
      final_version = @process.final_draft_version

      if final_version.present?
        redirect_to legislation_process_draft_version_path(@process, final_version)
      else
        render :phase_empty
      end
    else
      render :phase_not_open
    end
  end

  def milestones
    @phase = :milestones
  end

  def summary
    @phase = :summary
    @proposals = @process.proposals.selected
    @comments = @process.draft_versions.published.last&.best_comments || Comment.none

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "summary", filename: "summary-#{Date.current}.xlsx" }
    end
  end

  def proposals
    @phase = :proposals_phase

    @proposals = ::Legislation::Proposal.where(process: @process).filter_by(params[:advanced_search])
    @proposals = @proposals.search(params[:search]) if params[:search].present?

    @current_filter = "winners" if params[:filter].blank? && @proposals.winners.any?

    if @current_filter == "random"
      @proposals = @proposals.sort_by_random(session[:random_seed]).page(params[:page])
    else
      @proposals = @proposals.send(@current_filter).page(params[:page])
    end

    if @process.proposals_phase.started? || current_user&.administrator?
      render :proposals
    else
      render :phase_not_open
    end
  end

  def review
    @phase = :review_phase

    if @process.review_phase.started?
      first_review = @process.reviews.first

      if first_review.present?
        redirect_to legislation_process_review_path(@process, first_review)
      else
        render :phase_empty
      end
    else
      render :phase_not_open
    end
  end

  private

    def member_method?
      params[:id].present?
    end

    def set_process
      return if member_method?

      @process = ::Legislation::Process.find(params[:process_id])
    end
end
