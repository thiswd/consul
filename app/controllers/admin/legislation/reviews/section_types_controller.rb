class Admin::Legislation::Reviews::SectionTypesController < Admin::Legislation::BaseController
  before_action :load_review
  before_action :load_process, only: [:new, :edit]
  before_action :load_section_type, only: [:edit, :update, :destroy]

  def new
    @section_type = @review.section_types.new
  end

  def create
    @section_type = @review.section_types.new(section_type_params)

    if @section_type.save
      redirect_to admin_legislation_review_path(@review),
        notice: t("admin.legislation.reviews.section_types.create.notice")
    else
      render :new
    end
  end

  def update
    if @section_type.update(section_type_params)
      redirect_to admin_legislation_review_path(@review),
        notice: t("admin.legislation.reviews.section_types.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @section_type.destroy!
    redirect_to admin_legislation_review_path(@review),
      notice: t("admin.legislation.reviews.section_types.delete.notice")
  end

  private

    def load_review
      @review ||= ::Legislation::Review.find(params[:review_id])
    end

    def load_process
      @process ||= @review.process
    end

    def load_section_type
      @section_type ||= ::Legislation::Review::SectionType.find(params[:id])
    end

    def section_type_params
      params.require(:legislation_review_section_type).permit(
        [:title, poll_options_attributes: [:id, :title, :_destroy]]
      )
    end
end
