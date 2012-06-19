require 'parallel_issue_hook'
require 'parallel_issue_issue_patch'
require 'parallel_issues_controller_patch'

Redmine::Plugin.register :redmine_parallel_issue2 do
  name 'Redmine Parallel Issue2 plugin'
  author 'OZAWA Yasuhiro'
  description 'Multiple create issue for many subject and assignees,'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_parallel_issue'
  author_url 'http://blog.livedoor.jp/ameya86/'
end
