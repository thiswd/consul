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

  def user_section_vote(section)
    return unless current_user

    section.section_vote_for_user(current_user)
  end

  def find_or_build_section_vote(section)
    user_section_vote(section) || Legislation::Review::SectionVote.new
  end

  def hide_box
    if ["create", "update"].include?(params[:action])
      ""
    else
      "hide-fields"
    end
  end

  def section_vote_url(section_vote)
    if section_vote.new_record?
      legislation_process_review_section_votes_path(@process, @review)
    else
      legislation_process_review_section_vote_path(@process, @review, section_vote)
    end
  end

  def section_vote_submit(section_vote)
    section_vote.new_record? ? "new" : "edit"
  end

  def review_votes_count_title
    @process.review_phase.closed? ? "finished_contributions" : "contributions"
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
