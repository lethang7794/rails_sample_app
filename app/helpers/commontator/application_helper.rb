module Commontator::ApplicationHelper
  include UsersHelper
  include SessionsHelper

  def javascript_proc
    Commontator.javascript_proc.call(self).html_safe
  end
end
