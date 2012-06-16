class Issue < ActiveRecord::Base
  # 担当者割り当てで使う一時保存用変数
  attr_accessor :parallel_assignee_ids
end
