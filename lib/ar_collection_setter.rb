AR_COLLECTION_SETTER = ->(input:, binding:, **) do
   getter = binding[:getter]
   collection = getter.nil? ? send(binding.getter) : getter.evaluate(self)

  # Hard-delete records that are being replaced
  # Any further dependent records must be handled with foreign key constraints
  if collection.is_a?(ActiveRecord::Associations::CollectionProxy)
    if collection.respond_to?(:loaded?) && !collection.loaded?
      collection.delete_all :delete_all
    else
      collection.group_by(&:class).each do |klass, items|
        klass.where(id: items.map(&:id)).delete_all
      end
    end
  end

  # Don't use the collection= method (setter) so we can return meaningful errors
  input.each { |record| collection << record }
end
