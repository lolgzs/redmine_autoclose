class CreateAutocloseIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :autoclose_issues do |t|
      t.boolean :autoclose
      t.integer :issue_id
    end
    add_index :autoclose_issues, :issue_id
  end
end
