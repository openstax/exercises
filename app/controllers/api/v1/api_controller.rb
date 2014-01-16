module Api
  module V1
    class ApiController < ApplicationController  
      include Roar::Rails::ControllerAdditions

      skip_before_filter :authenticate_user!
      respond_to :json
      rescue_from Exception, :with => :rescue_from_exception
      
      # TODO doorkeeper users (or rather users who have doorkeeper applications) need to agree to 
      # API terms of use (need to have agreed to it at one time, can't require them to agree when 
      # terms change since their apps are doing the talking) -- this needs more thought

      def current_user
        @current_user ||= doorkeeper_token ? 
                          User.find(doorkeeper_token.resource_owner_id) : 
                          super
        # TODO maybe freak out if current user is anonymous (require we know who person/app is
        # so we can do things like throttling, API terms agreement, etc)
      end

    protected

      def rescue_from_exception(exception)
        # See https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453 for error names/symbols

        error = :internal_server_error
        send_email = true
    
        case exception
        when SecurityTransgression
          error = :forbidden
          send_email = false
        when ActiveRecord::RecordNotFound, 
             ActionController::RoutingError,
             ActionController::UnknownController,
             AbstractController::ActionNotFound
          error = :not_found
          send_email = false
        end

        ExceptionNotifier::Notifier.exception_notification(
          request.env,
          exception,
          :data => {:message => "An exception occurred"}
        ).deliver if send_email

        
        Rails.logger.debug("An exception occurred: #{exception.inspect}") if Rails.env.development?

        head error
      end

      def self.json_schema(representer, options={})
        options[:indent] ||= FUNKY_INDENT_CHARS

        "
        Schema  {##{SecureRandom.hex(4)} .schema}
        ------
        <pre class='code'>
        #{RepresentableSchemaPrinter.json(representer, options)}
        </pre>
        "
      end

      # A hack at a conversion from a Representer to a series of Apipie declarations
      # Can call it like any Apipie DSL method, 
      #
      #  example "blah"
      #  representer Api::V1::ExerciseRepresenter
      #  def update ...
      #
      def self.representer(representer)
        representer.representable_attrs.each do |attr|
          schema_info = attr.options[:schema_info] || {}
          param attr.name, (attr.options[:type] || Object), required: schema_info[:required]
        end
      end

      def get_representer(represent_with, model=nil)
        return nil if represent_with.nil?
        if represent_with.is_a? Proc
          represent_with.call(model)
        else
          represent_with
        end
      end

      def rest_get(model_klass, id, represent_with=nil)
        @model = model_klass.find(id)
        raise SecurityTransgression unless current_user.can_read?(@model)
        respond_with @model, represent_with: get_representer(represent_with, @model)
      end

      def rest_update(model_klass, id, represent_with=nil)
        @model = model_klass.find(id)
        raise SecurityTransgression unless current_user.can_update?(@model)
        consume!(@model, represent_with: get_representer(represent_with, @model))
        
        if @model.save
          head :no_content
        else
          render json: @model.errors, status: :unprocessable_entity
        end
      end

      def rest_create(model_klass)
        @model = model_klass.new()
        consume!(@model)
        raise SecurityTransgression unless current_user.can_create?(@model)

        if @model.save
          respond_with @model
        else
          render json: @model.errors, status: :unprocessable_entity
        end
      end

      def rest_destroy(model_klass, id)
        @model = model_klass.find(id)
        raise SecurityTransgression unless current_user.can_destroy?(@model)
        
        if @model.destroy
          head :no_content
        else
          render json: @model.errors, status: :unprocessable_entity
        end
      end

      def standard_sort(model_klass)
        # take array of all IDs or hash of id => position,
        # regardless build up an array of all IDs in the right order and pass those to sort

        new_positions = params['newPositions']
        return head :no_content if new_positions.length == 0

        # Can't have duplicate positions or IDs
        unique_ids =       new_positions.collect{|np| np['id']}.uniq
        unique_positions = new_positions.collect{|np| np['position']}.uniq

        return head :bad_request if unique_ids.length != new_positions.length
        return head :bad_request if unique_positions.length != new_positions.length

        first = model_klass.where(:id => new_positions[0]['id']).first

        return head :not_found if first.blank?

        originalOrdered = first.me_and_peers.ordered.all

        originalOrdered.each do |item|
          raise SecurityTransgression unless item.send(:container_column) == originalOrdered[0].send(:container_column) \
            if item.respond_to?(:container_column)
          raise SecurityTransgression unless current_user.can_sort?(item)
        end

        originalOrderedIds = originalOrdered.collect{|sc| sc.id}

        newOrderedIds = Array.new(originalOrderedIds.size)
      
        new_positions.each do |newPosition|
          id = newPosition['id'].to_i
          newOrderedIds[newPosition['position']] = id
          originalOrderedIds.delete(id)
        end

        ptr = 0
        for oldId in originalOrderedIds 
          while !newOrderedIds[ptr].nil?; ptr += 1; end
          newOrderedIds[ptr] = oldId
        end

        begin 
          model_klass.sort!(newOrderedIds)
        rescue Exception => e
          return head :internal_server_error
        end

        head :no_content
      end

    end
  end
end