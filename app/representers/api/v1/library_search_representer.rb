module Api::V1
  class LibrarySearchRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :name,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               description: "The query name string."
             }

    property :language,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               description: "The query language string."
             }

    property :num_matching_libraries,
             type: Integer,
             readable: true,
             writeable: false,
             schema_info: {
               description: "The number of libraries that match the query, can be more than the number returned"
             }

    property :page,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               description: "The current page number of the returned results"
             }

    property :per_page,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               description: "The number of results per page"
             }

    property :order_by,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               description: "The ordering info, which may be different than what was requested if the request was missing defaults or had bad settings."
             }

    collection :libraries,
               class: Library,
               decorator: LibraryRepresenter,
               readable: true,
               writeable: true,
               schema_info: {
                 description: "The libraries matching the query or a subset thereof when paginating"
               }

  end
end
