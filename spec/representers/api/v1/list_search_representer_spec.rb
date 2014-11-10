module Api::V1
  class ListSearchRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :name,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               description: "The query name string."
             }

    property :visibility,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               description: "The query visibility string."
             }

    property :num_matching_lists,
             type: Integer,
             writeable: false,
             readable: true,
             schema_info: {
               description: "The number of lists that match the query, can be more than the number returned"
             }

    property :page,
             type: Integer, 
             writeable: true,
             readable: true,
             schema_info: {
               description: "The current page number of the returned results"
             }

    property :per_page,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               description: "The number of results per page"
             }

    property :order_by,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               description: "The ordering info, which may be different than what was requested if the request was missing defaults or had bad settings."
             }

    collection :lists,
               class: List,
               decorator: ListRepresenter,
               readable: true,
               writeable: false,
               schema_info: {
                 description: "The lists matching the query or a subset thereof when paginating"
               }

  end
end
