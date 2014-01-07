module Sortable
  module View
    def self.included(base)
      base.class_eval do
        attr_accessor :current_sortable_position
      end
    end

    def sortable_content(sortable_object, name = 'div', classes = '', options = {}, escape = true, &block)
      options = options.merge({:id => "#{sortable_object.class.name.downcase}_#{sortable_object.id}",
                               :class => "#{classes} sortable_content"})
      content_tag(name, nil, options, escape, &block)
    end

    alias_method :sortable_content_tag, :sortable_content

    def sortable_handle(name = 'span', classes = 'ui-icon ui-icon-arrow-4', options = {}, escape = true, &block)
      options = options.merge({:class => "#{classes} sortable_handle"})
      content_tag(name, nil, options, escape, &block)
    end

    alias_method :sortable_handle_tag, :sortable_handle

    def sortable_position(scope_name = '', start_at = 1, name = 'span', classes = '', options = {}, escape = true)
      options = options.merge({:class => "#{classes} sortable_position",
                               :'data-sortable_scope' => scope_name,
                               :'data-sortable_start_at' => start_at})
      self.current_sortable_position ||= {}
      self.current_sortable_position[scope_name] = (current_sortable_position[scope_name] || (start_at - 1)) + 1
      content_tag(name, current_sortable_position[scope_name], options, escape)
    end

    alias_method :sortable_position_tag, :sortable_position
  end
end

ActionView::Base.send :include, Sortable::View
