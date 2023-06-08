class Admin::Legislation::ReviewsController < Admin::Legislation::BaseController
  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :review, class: "Legislation::Review"

  before_action :load_process, only: [:show, :edit]
  before_action :load_section_types, only: :show
  before_action :load_sections, only: :show

  def index
    @reviews = @process.reviews
  end

  def new
    @review = @process.reviews.new
  end

  def create
    @review = @process.reviews.new(review_params)
    @review.user_id = current_user.id

    if @review.save
      redirect_to admin_legislation_review_path(@review),
        notice: t("admin.legislation.reviews.create.notice")
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to admin_legislation_review_path(@review),
        notice: t("admin.legislation.reviews.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @review.destroy!
    redirect_to admin_legislation_process_reviews_path,
      notice: t("admin.legislation.reviews.delete.notice")
  end

  private

    def review_params
      params.require(:legislation_review).permit([:title])
    end

    def load_process
      @process ||= @review.process
    end

    def load_section_types
      @section_types ||= @review.section_types
    end

    def load_sections
      @sections ||= @review.root_sections
    end
end
