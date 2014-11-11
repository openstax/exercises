module Api::V1
  class Stylable

    include Roar::Representer::JSON

    collection :formats,
               type: String,
               writeable: true,
               readable: true,
               getter: lambda { |*| stylings.collect{|s| s.style} },
               setter: lambda { |val| s = stylings.find_or_initialize_by(
                                            style: val)
                                      stylings << s unless s.persisted? },
               schema_info: {
                 required: true,
                 description: 'The formats allowed for this object'
               }

  end
end
