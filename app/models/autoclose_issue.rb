class AutocloseIssue < ApplicationRecord
  belongs_to :issue
  validates :issue_id, presence: true
  validates :autoclose, inclusion: { in: [true, false] }  
end
