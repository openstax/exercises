module Api::V1
  class LibrarySearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: Library,
                       decorator: LibraryRepresenter

  end
end
