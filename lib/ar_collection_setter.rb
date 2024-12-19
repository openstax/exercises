AR_COLLECTION_SETTER = ->(binding:, input:, **options) do
  # Get the collection object to be replaced
  # If a custom getter is set in binding[:getter], use that
  # Otherwise, use the default getter in binding.getter
  collection = binding[:getter].nil? ? send(binding.getter) : binding.evaluate_option(:getter, self, options)
  collection.replace input
end
