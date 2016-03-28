module Solution
  module ActiveRecord
    module Base
      def solution
        class_exec do

          acts_as_votable
          user_html :content
          has_attachments
          has_logic :javascript, :latex
          stylable

          belongs_to :question

          validates :question, presence: true
          validates :solution_type, presence: true, inclusion: { in: SolutionType.all }
          validates :content, presence: true

        end
      end
    end
  end

  module Roar
    module Decorator
      def solution
        has_logic
        has_attachments

        property :title,
                 type: String,
                 writeable: true,
                 readable: true

        property :solution_type,
                 type: String,
                 writeable: true,
                 readable: true

        property :content,
                 as: :content_html,
                 type: String,
                 writeable: true,
                 readable: true
      end
    end
  end
end

ActiveRecord::Base.extend Solution::ActiveRecord::Base
Roar::Decorator.extend Solution::Roar::Decorator
