module Api::V1
  class PublicationsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a publishable object.'
      description <<-EOS
        Publications contain information about the publication status of
        publishable objects, such as Exercises and Solutions.
      EOS
    end

    ########
    # show #
    ########

    api :POST, '/publications/:publication_id', 'Gets the specified Publication'
    description <<-EOS
      Gets the Publication that matches the provided ID.
      The Publication contains information about the
      publication status of a publishable object.

      #{json_schema(Api::V1::PublicationRepresenter, include: :writeable)}   
    EOS
    def publish
    end

    ###########
    # publish #
    ###########

    api :POST, '/publications/:publication_id', 'Sets the specified Publication as published'
    description <<-EOS
      Sets the Publication that matches the provided ID as published.  
    EOS
    def publish
    end

  end
end
