class Admin::Legislation::ReviewsController < Admin::Legislation::BaseController
  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :review, class: "Legislation::Review", through: :process

  def index
    @reviews = @process.reviews
  end

  def new
    @review = @process.reviews.new
  end

  def create
    @review = @process.reviews.new(review_params)
    @review.user_id = current_user

    if @review.save
      redirect_to admin_legislation_process_review_path(@process, @review),
        notice: t("admin.legislation.reviews.create.notice")
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to admin_legislation_process_review_path(@process, @review),
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

  def resource
    @review || ::Legislation::Review.find(params[:id])
  end

  def load_section_classifications
    @section_classifications = @review.section_classifications
  end
end
