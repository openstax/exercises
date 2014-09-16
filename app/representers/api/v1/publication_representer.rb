module Api::V1
  class PublicationRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :number,
             type: Integer,
             writeable: false,
             readable: true

    property :version,
             type: Integer,
             writeable: false,
             readable: true

    property :license,
             class: License,
             decorator: LicenseRepresenter,
             writeable: true,
             readable: true,
             setter: lambda { |val|
              self.license = License.find_by(name: val[:name])
             }

    collection :derivations,
               as: :derived_from,
               class: Publication,
               decorator: PublicationRepresenter,
               writeable: true,
               readable: true

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
      raise Exception, "TODO"
      represented.collaborators.authors = authors
    end

    def copyright_holders
      represented.collaborators.copyright_holders
    end

    def copyright_holders=(copyright_holders)
      raise Exception, "TODO"
      represented.collaborators.copyright_holders = copyright_holders
    end
  end
end
