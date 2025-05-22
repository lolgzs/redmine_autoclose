module RedmineAutoclose
  module Patches
    module IssuesControllerPatch
      extend ActiveSupport::Concern

      included do
        before_action :handle_autoclose, only: [:update]
      end

      private

      def handle_autoclose
        return unless params[:issue] && params[:issue][:autoclose].present?

        autoclose_enabled = params[:issue][:autoclose] == '1'
        update_autoclose_and_journal(autoclose_enabled)
      end

      
      def update_autoclose_and_journal(autoclose_enabled)
        if @issue.autoclose_issue
          update_existing_autoclose(autoclose_enabled)
        else
          create_new_autoclose(autoclose_enabled)
        end
      end

      
      def update_existing_autoclose(autoclose_enabled)
        @issue.autoclose_issue.update(autoclose: autoclose_enabled)
        add_journal_entry(@issue.autoclose_issue.autoclose_was, autoclose_enabled)
      end
      

      def create_new_autoclose(autoclose_enabled)
        @issue.create_autoclose_issue(autoclose: autoclose_enabled)
        add_journal_entry(nil, autoclose_enabled)
      end


      def add_journal_entry(old_value, new_value)
        @issue.init_journal(User.current)
        @issue.current_journal.details << JournalDetail.new(
          property: 'attr',
          prop_key: 'autoclose',
          old_value: old_value,
          value: new_value
        )
        @issue.current_journal.save
      end

    end
  end
end

# Applique le patch au contrôleur IssuesController
IssuesController.send(:include, RedmineAutoclose::Patches::IssuesControllerPatch)
