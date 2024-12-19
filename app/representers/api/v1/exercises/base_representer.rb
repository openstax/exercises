module Api::V1::Exercises
  class BaseRepresenter < Roar::Decorator

    include Roar::JSON

    CACHED_PUBLIC_FIELDS  = ->(options) do
      options[:user_options][:render].blank? || options[:user_options][:render] == :cached_public
    end
    CACHED_PRIVATE_FIELDS = ->(options) do
      options[:user_options][:render].blank? || options[:user_options][:render] == :cached_private
    end
    UNCACHED_FIELDS       = ->(options) do
      options[:user_options][:render].blank? || options[:user_options][:render] == :uncached
    end

  end
end
