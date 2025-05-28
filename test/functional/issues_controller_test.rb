require File.expand_path('../../test_helper', __FILE__)

class IssuesControllerTest < ActionController::TestCase
  fixtures :users, :projects, :issues, :issue_statuses

  def setup
    @user = users(:users_001) 
    @project = projects(:projects_001)
    @issue = issues(:issues_001) 
    @controller = IssuesController.new

    # Enable autoclose for this issue tracker
    @settings = {
      autoclose_tracker_ids: [@issue.tracker_id.to_s]
    }
    Setting.plugin_redmine_autoclose = @settings
    if @issue.autoclose_issue
      @issue.autoclose_issue.delete
    end
  end

  test "GET #show show by default 'Automatic close: No'" do
    get :show, params: { id: @issue.id }
    assert_response :success
    assert_select 'div[@class="attribute"]:has(span[text()="Automatic close"])' do
      assert_select 'div', "No"
    end
  end

  test "GET #edit show unchecked checkbox for issue autoclose by default" do
    @request.session[:user_id] = 1
    get :edit, params: { id: @issue.id }
    assert_response :success
    assert_select 'input[name=?]:not([checked])', 'issue[autoclose]'
  end

  test "PATCH #update with checked autoclose save autoclose_issue object with value true" do
    patch :update, params: { id: @issue.id, issue: { autoclose: '1' } }
    assert_redirected_to issue_path(@issue)
    @issue.reload
    assert @issue.autoclose_issue.autoclose
  end

  test "PATCH #update  with unchecked autoclose save autoclose_issue object with value false" do
    patch :update, params: { id: @issue.id, issue: { autoclose: '0' } }
    assert_redirected_to issue_path(@issue)
    @issue.reload
    assert_not @issue.autoclose_issue.autoclose
  end

  test "GET #edit show checked checkbox for issue with autoclose true" do
    @request.session[:user_id] = 1
    @issue.create_autoclose_issue(autoclose: true)
    
    get :edit, params: { id: @issue.id }
    
    assert_response :success
    assert_select 'input[name=?][checked=checked]', 'issue[autoclose]'
  end

end
