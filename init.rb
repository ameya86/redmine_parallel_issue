require 'redmine'
require 'parallel_issue_hook'
require 'parallel_issue_issue_patch'
require 'parallel_issues_controller_patch'

Redmine::Plugin.register :redmine_parallel_issue do
  name 'Redmine Parallel Issue plugin'
  author 'OZAWA Yasuhiro'
  description 'Multiple create issue for many assignees,'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_parallel_issue'
  author_url 'http://blog.livedoor.jp/ameya86/'
end
