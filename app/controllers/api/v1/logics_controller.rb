module Api::V1
  class LogicsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Blocks of code used to make dynamically-generated variations of Logics and Solutions'
      description <<-EOS
        #{SITE_NAME} uses Javascript to make logics "dynamic".  Authors write
        small bits of Javascript to compute variables that are substituted into special
        placeholders in the logic content.  When the Javascript uses the available 
        randomization routines, different students will see different computer-generated
        permutations of the exericse.

        For a number of reasons, we do not run the author's Javascript in a student's browser
        when they view the logic &ndash; instead, the Javascript is run in the author's browser
        (during the authoring process).  When a "Logic" attached to an Exercise is saved,
        the client is responsible for sending along a number of output runs of the code,
        called "Logic Variable Value"s.  With, say, 100 of these Logic Variable Values,
        we can safely provide a number of permutations to a group of students.

        A Logic consists of some "code" as well as a list of exported variables.  These
        explicitly listed variables tell us which of the many variables available in the code
        the author wants to have available in the Logic content.  There are several 
        restrictions on the code and variables saved:

        1. The "code" data cannot contain the following standard Javascript reserved words: 
           > #{Logic::JS_RESERVED_WORDS.join(', ')}
        2. The "code" data also cannot contain the follow special reserved words:
           > #{Logic::OTHER_RESERVED_WORDS.join(', ')}
        3. The "variables" data must be a JSON stringified array of string objects, each of
           which must match the following regular expression: #{Logic::VARIABLE_REGEX.inspect}
      EOS
    end

    api :GET, '/logics/:id', 'Gets the specified Logic'
    description <<-EOS
      #{json_schema(Api::V1::LogicRepresenter, include: :readable)}        
    EOS
    def show
      rest_get(Logic, params[:id])
    end

    api :PUT, '/logics/:id', 'Updates the specified Logic'
    description <<-EOS
      Updates the Logic object whose ID matches the provided param.
    EOS
    def update
      # Logic.transaction do 
        rest_update(Logic, params[:id])
      # end
    end

    api :POST, '/logics', 'Creates a new Logic with the specified parameters'
    def create
      rest_create(Logic)
    end

    api :DELETE, '/logics/:id', 'Deletes the specified Logic'
    def destroy
      rest_destroy(Logic, params[:id])
    end
    
  end
end
