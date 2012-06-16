class ParallelIssue < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => 'parallel_issues/issues_form_details_bottom'

  # チケット保存前に、適当な担当者を1人割り当てておく
  def controller_issues_new_before_save(context = {})
    params = context[:params]
    issue = context[:issue]
    if issue && params[:issue] && params[:issue][:parallel_assignee_ids].present?
      issue.parallel_assignee_ids = params[:issue][:parallel_assignee_ids].uniq
      issue.assigned_to_id = issue.parallel_assignee_ids.shift
    end
  end

  # チケット保存後に、チケットをコピーして、残りの担当者を振り分ける
  def controller_issues_new_after_save(context = {})
    issue = context[:issue]
    issue.parallel_assignee_ids.each do |assignee_id|
      copied_issue = issue.copy
      copied_issue.assigned_to_id = assignee_id
      copied_issue.save
    end if !issue.new_record? && issue.parallel_assignee_ids.present?
  end
end
