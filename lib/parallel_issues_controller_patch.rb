require_dependency 'issues_controller'

module IssuesControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods) # self.method

    base.send(:include, InstanceMethods) # obj.method

    base.class_eval do
      alias_method_chain :new, :parallel
    end
  end

  module ClassMethods # self.method
  end

  module InstanceMethods # obj.method
    def new_with_parallel
      if 'POST' == request.method.to_s.upcase
        respond_to do |format|
          format.js {
            render(:update) do |page|
              page.replace_html 'attributes', :partial => 'attributes_parallel'
            end
          }
        end
      else
        new_without_parallel
      end
    end
  end
end

IssuesController.send(:include, IssuesControllerPatch)
