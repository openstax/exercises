# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module ApplicationHelper
  include SharedApplicationMethods

  def vertical_bar(options={})
    options = add_class(options, "vertical-bar")
    content_tag :span, nil, options
  end

  def add_class(options, klass)
    klasses = options.fetch(:class, "") + " vertical-bar "
    options[:class] = klasses;
    options
  end

  def page_heading(heading_text, options={})
    options[:take_out_site_name] = true if options[:take_out_site_name].nil?
    options[:sub_heading_text] ||= ""
    options[:title_text] ||= heading_text + (options[:sub_heading_text].blank? ? 
                                             "" : 
                                             " [#{options[:sub_heading_text]}]")
    
    @page_title = options[:title_text]
    @page_title.sub!(SITE_NAME, "").strip! if @page_title.include?(SITE_NAME) && options[:take_out_site_name]
    
    return if heading_text.blank?
    
    content_for :page_heading do
      render(:partial => 'shared/page_heading', 
             :locals => {:heading_text => heading_text, 
                         :sub_heading_text => options[:sub_heading_text]})
    end
  end

  def partial_width_block(&block)
    content_tag :div, :class => 'partial-width-block' do
      (capture(&block)).html_safe
    end
  end

  def section(title, options={}, &block)
    block_to_partial('shared/section', 
                     options.merge(:title => title), 
                     &block)
  end

  def yn(bool)
    bool ? 'Yes' : 'No'
  end

  def name_link(object)
    link_to object.name, object
  end

  def hide_email(email)
    address, domain = email.split('@')
    lld, tld = domain.split('.')

    adress = '***' if address.nil?
    lld = '***' if lld.nil?
    tld = '***' if tld.nil?

    "***@#{lld}.#{tld}"
  end

  def submit_classes
    "ui-state-default ui-corner-all submitButton"
  end

  def please_wait
    '$(this).blur().hide().parent().append("Please wait...");'
  end

  def unless_errors(options={}, &block)
    errors = @handler_result.errors.each do |error|
      add_local_error_alert now: true, content: error.translate
    end

    @handler_result.errors.any? ?
      js_refresh_alerts(options) : 
      js_refresh_alerts(options) + capture(&block).html_safe
  end

  def js_refresh_alerts(options={})
    options[:alerts_html_id] ||= 'local-alerts'
    options[:alerts_partial] ||= 'shared/local_alerts'
    options[:trigger] ||= 'alerts-updated'    

    "$('##{options[:alerts_html_id]}').html('#{ j(render options[:alerts_partial]) }').trigger('#{options[:trigger]}');".html_safe
  end

  # def form_group(options={})

  #   raise IllegalArgument, "Must specify a :label" if !options[:label] 
  #   raise IllegalArgument, "Must specify a :type" if !options[:type] 
  #   raise IllegalArgument, "Must specify a :form" if !options[:form] 
  #   raise IllegalArgument, "Must specify a :name" if !options[:name] 

  #   options[:options] ||= {}
  #   options[:options][:class] ||= ''
  #   options[:options][:class] += ' form-control'
  #   options[:label_classes] ||= ''
  #   options[:field_classes] ||= ''


  #   content_tag :div, class: 'form-group' do
  #     (content_tag :label, class: 'control-label ' + options[:label_classes] do
  #             options[:label]
  #     end) + 
  #     (content_tag :div, class: 'form-input ' + options[:field_classes] do
  #       case options[:type] 
  #       when :text_field
  #         options[:form].text_field(options[:name], options[:options])
  #       when :password_field
  #         options[:form].password_field(options[:name], options[:options])
  #       else
  #         raise IllegalArgument, "Unknown field type #{options[:type]}"
  #       end
  #     end)
  #   end
  # end
end
