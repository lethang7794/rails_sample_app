module ApplicationHelper

  # return full page title on a per-page basis
  def full_title(page_title = '')
    base_title = 'Sample App'
    if page_title.blank?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
