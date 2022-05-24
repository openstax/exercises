AR_COLLECTION_SETTER = ->(input:, binding:, **) do
  getter = binding[:getter]
  collection = getter.nil? ? send(binding.getter) : getter.evaluate(self)
  collection.replace input
end
