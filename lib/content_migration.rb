module Contents
  module Migration
    module Columns
      def content(names = 'content')
        names_array = names.is_a?(Array) ? names.collect{|name| name.to_s} : [names.to_s]

        names_array.each do |name|
          text name.to_sym, null: false, default: ''
          text "#{name}_html".to_sym, null: false, default: ''
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Contents::Migration::Columns
