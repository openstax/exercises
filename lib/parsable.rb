module Parsable
  module ActiveRecord
    module Base
      def parsable(*attributes)
        attributes.each do |attribute|
          filter_name = "parse_#{attribute.to_s}"

          class_exec do
            before_validation filter_name

            define_method(filter_name) do
              send("#{attribute}=", ParseContent.call(send(attribute)).outputs[:content])
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend Parsable::ActiveRecord::Base
