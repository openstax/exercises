module Api::V1::Exercises
  class VersionsRepresenter < BaseRepresenter

    collection :versions,
               type: Array,
               writeable: false,
               readable: true,
               getter: ->(user_options:, **) do
                 visible_versions(
                   can_view_solutions: user_options[:can_view_solutions] ||
                                       can_view_solutions?(user_options[:user])
                 )
               end

  end
end
