require File.expand_path('../../test_helper', __FILE__)

class IssuesControllerTest < ActionController::TestCase
  fixtures :users, :projects, :issues, :issue_statuses

  def setup
    @user = users(:users_001) 
    @project = projects(:projects_001)
    @issue = issues(:issues_001) 
    @controller = IssuesController.new
  end

  test "GET #show show by default 'Automatic close: No'" do
    get :show, params: { id: @issue.id }
    assert_response :success
    assert_match /Automatic close: No/, @response.body
  end

  test "GET #edit show unchecked checkbox for issue autoclose by default" do
    get :edit, params: { id: @issue.id }
    assert_response :success
    assert_select 'input[name="issue[autoclose]"]:not(:checked)'
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
end
