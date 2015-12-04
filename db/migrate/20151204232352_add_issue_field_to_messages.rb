class AddIssueFieldToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :issue, :text
  end
end
