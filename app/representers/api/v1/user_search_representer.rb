class Api::V1::UserSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter
  collection :items, inherit: true, class: User, extend: Api::V1::UserRepresenter
end
