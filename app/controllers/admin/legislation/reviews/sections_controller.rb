class Admin::Legislation::Reviews::SectionsController < Admin::Legislation::BaseController
  load_and_authorize_resource :review, class: "Legislation::Review"
  load_and_authorize_resource :section, class: "Legislation::Review::Section"

  before_action :load_section_types, only: [:new, :create]
  before_action :load_associated_section_type, only: [:edit, :update]
  before_action :load_section_type, only: [:new, :create]
  before_action :load_parent, only: [:new, :create]
  before_action :load_process, only: [:new, :edit]

  def new
    @section = @review.sections.new
  end

  def create
    @section = @review.sections.new(section_params)

    if @section.save
      redirect_to admin_legislation_review_path(@review),
        notice: t("admin.legislation.review.sections.create.notice")
    else
      render :new
    end
  end

  def update
    if @section.update(section_params)
      redirect_to admin_legislation_review_path(@review),
        notice: t("admin.legislation.review.sections.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @section.destroy!
    redirect_to admin_legislation_review_path(@review),
      notice: t("admin.legislation.review.sections.delete.notice")
  end

  private

    def section_params
      params.require(:legislation_review_section).permit([
        :title, :description, :review_section_section_type_id, :parent_id, :evaluable
      ])
    end

    def load_section_types
      @section_types ||= @review.section_types
    end

    def load_section_type
      @section_type ||= @review.section_types.find(review_section_section_type_id)
    end

    def load_associated_section_type
      @section_type = @section.section_type
    end

    def load_parent
      @parent = @review.sections.find(parent_id) if parent_id.present?
    end

    def load_process
      @process ||= @review.process
    end

    def parent_id
      section_params[:parent_id]
    end

    def review_section_section_type_id
      section_params[:review_section_section_type_id]
    end
end
