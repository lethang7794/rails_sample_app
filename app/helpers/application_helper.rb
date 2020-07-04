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

  # Return the current path without forward slash in the end.
  # To compare with urls generated form path helper which don't have it.
  def current_path
    request.original_fullpath.sub(/\/\z/, '')
  end
end
