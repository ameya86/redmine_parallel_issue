class ParallelIssue < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => 'parallel_issues/issues_form_details_bottom'

  # チケット保存前に、適当な題名、担当者を1人割り当てておく
  def controller_issues_new_before_save(context = {})
    params = context[:params]
    issue = context[:issue]
    if issue && params[:issue]
      # 題名
      if params[:issue][:parallel_subjects].present?
        issue.parallel_subjects = params[:issue][:parallel_subjects].split(/\r?\n/)
        issue.subject = issue.parallel_subjects.shift
      end

      # 担当者
      if params[:issue][:parallel_assignee_ids].present?
        issue.parallel_assignee_ids = params[:issue][:parallel_assignee_ids].uniq
        issue.assigned_to_id = issue.parallel_assignee_ids.shift
      end
    end
  end

  # チケット保存後に、チケットをコピーして、残りの担当者を振り分ける
  def controller_issues_new_after_save(context = {})
    issue = context[:issue]

    # 題名
    # 1つ目の題名で担当者分複製
    copy_parallel_assignees_issue(issue)
    issue.parallel_subjects.each do |subject|
      copied_issue = issue.copy
      copied_issue.subject = subject
      copied_issue.save
      copied_issue.parallel_assignee_ids = issue.parallel_assignee_ids
      # 担当者分、さらに複製する
      copy_parallel_assignees_issue(copied_issue)
    end if !issue.new_record? && issue.parallel_subjects.present?
  end

  # 複数選択された担当者分、複製する
  def copy_parallel_assignees_issue(issue)
    issue.parallel_assignee_ids.each do |assignee_id|
      copied_issue = issue.copy
      copied_issue.assigned_to_id = assignee_id
      copied_issue.save
    end if !issue.new_record? && issue.parallel_assignee_ids.present?
  end
end
