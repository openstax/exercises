module Api
  module V1

    class DummyController < ApiController     
      def index
        @object = {foo: :bar}
        # raise SecurityTransgression unless current_user.can_read?(@object)
      end
      
    end
  end
+end