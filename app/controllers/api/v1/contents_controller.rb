module Api
  module V1

    class ContentsController < ApiController 

      # NOT PLANNING ON HAVING CONTENTS ACCESSIBLE VIA THE API, NEED TO GET/SET VIA PARENT

      # resource_description do
      #   api_versions "v1"
      #   short_description 'A Content is used to store OpenStax Exercises markup and that markup''s corresponding HTML.'
      #   description <<-EOS
      #     When communicating via the API, Lorem ipsum dolor sit amet, consectetur 
      #     adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore 
      #       magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco 
      #       laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor 
      #       in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
      #       pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa 
      #       qui officia deserunt mollit anim id est laborum. 
      #   EOS
      # end

      # #########################################################################

      # api :GET, '/contents/:id', 'Returns the specified Content'
      # description <<-EOS
      #   Returns the Content object whose ID matches the provided param.
      # EOS
      # example <<-EOS
      #   { 
      #     id: 2,
      #     markup: "Jack was a very _dull_ boy",
      #     html: "Jack was a very <i>dull</i> boy"
      #   }
      # EOS
      # def show
      #   @content = Content.find(params[:id])
      #   raise SecurityTransgression unless current_user.can_read?(@content)
      # end

      # #########################################################################

      # api :PUT, '/contents/:id', 'Updates the specified Content'
      # description <<-EOS
      #   Updates the Content object whose ID matches the provided param.  Any provided html will
      #   be ignored.

      #   #{json_schema(Api::V1::ContentRepresenter, include: :writeable)}        
      # EOS
      # example <<-EOS        
      #   { 
      #     "id": 2,
      #     "markup": "Jack was a very _dull_ boy",
      #   }
      # EOS
      # def update
      #   @content = Content.find(params[:id])

      #   if @content.update_attributes(params[:content])
      #     head :no_content
      #   else
      #     render json: @content.errors, status: :unprocessable_entity
      #   end
      # end
      
    end
  end
end