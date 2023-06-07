module LegislationReviewsHelper
  def section_type_label(indexes)
    "#{indexes.*(".")}."
  end

  def section_indexes(indexes, index, counter_level)
    if index == 1
      indexes << index
    else
      indexes = indexes.first(counter_level)
      indexes[-1] = index
    end
    indexes
  end

  def delete_section_confirmation(section)
    if section.children.any?
      { confirm: destroy_section_message(section) }
    end
  end

  private

    def destroy_section_message(section)
      t(
        "admin.legislation.sections.destroy.confirm",
        title: section.title,
        count: section.descendants.size
      )
    end
end
