require File.expand_path('../../test_helper', __FILE__)

class IssuePatchTest < ActiveSupport::TestCase
  fixtures :projects, :issues

  def setup
    @issue = Issue.find(1)
  end

  test "should responds to autoclose" do
    assert @issue.respond_to?(:autoclose)
  end

  
  test "should default autoclose to false" do
    issue = Issue.new
    assert_equal false, issue.autoclose
  end

  test "should have autoclose_enabled false" do
    issue = Issue.new
    assert_equal false, issue.autoclose_enabled
  end
end
