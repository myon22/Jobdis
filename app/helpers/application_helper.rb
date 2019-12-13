module ApplicationHelper

  def page_title(title="")
    unless title.empty?
      title + " | Job Dis"
    else
      "Job Dis"
    end
  end
end
