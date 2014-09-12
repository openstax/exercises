module HasCollaborators
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_collaborators
        class_exec do
          has_many :collaborators, as: :parent, dependent: :destroy
        end
      end
    end
  end

  module Representable
    module Declarative
      def has_collaborators
        class_exec do
          collection :collaborators,
                     class: Collaborator,
                     decorator: Api::V1::CollaboratorRepresenter,
                     writeable: true,
                     readable: true,
                     exec_context: :decorator

          collection :authors,
                     class: Collaborator,
                     decorator: Api::V1::CollaboratorRepresenter,
                     writeable: true,
                     readable: true,
                     exec_context: :decorator

          collection :copyright_holders,
                     class: Collaborator,
                     decorator: Api::V1::CollaboratorRepresenter,
                     writeable: true,
                     readable: true,
                     exec_context: :decorator

          def collaborators
            represented.collaborators
          end

          def collaborators=(collaborators)
            represented.collaborators = collaborators
          end

          def authors
            represented.collaborators.authors
          end

          def authors=(authors)
            represented.collaborators.authors = authors
          end

          def copyright_holders
            represented.collaborators.copyright_holders
          end

          def copyright_holders=(copyright_holders)
            represented.collaborators.copyright_holders = copyright_holders
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, HasCollaborators::ActiveRecord
Representable::Declarative.send :include, HasCollaborators::Representable::Declarative
