module RedmineAutoclose
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_show_details_bottom(context={ })
      context[:controller].send(:render_to_string, {
        :partial => "issues/show_autoclose",
        :locals => context
      })
    end

    def view_issues_form_details_bottom(context={ })
      context[:controller].send(:render_to_string, {
        :partial => "issues/edit_autoclose",
        :locals => context
      })
    end
  end
end
