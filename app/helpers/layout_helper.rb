# Copyright 2011-2019 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

module LayoutHelper
  ABOUT_TEXT           = "ABOUT"
  DASHBOARD_TEXT       = "DASHBOARD"
  COURSE_CATALOG_TEXT  = "COURSE CATALOG"
  CURRENT_CLASSES_TEXT = "CURRENT CLASSES"
  MY_TUTOR_TEXT        = "MY TUTOR"
  HELP_TEXT            = "HELP"

  def top_nav_about_link
    top_nav_render ABOUT_TEXT, target_path: "#"
  end

  def top_nav_dashboard_link
    top_nav_render DASHBOARD_TEXT
  end

  def top_nav_course_catalog_link
    top_nav_render COURSE_CATALOG_TEXT
  end

  def top_nav_current_classes_link
    top_nav_render CURRENT_CLASSES_TEXT, target_path: "#"
  end

  def top_nav_my_tutor_link
    top_nav_render MY_TUTOR_TEXT, target_path: "#"
  end

  def top_nav_help_link
    top_nav_render HELP_TEXT, target_path:  "#",
                              target_image: image_tag('help_icon_v4.png', class: 'help-link-icon')
  end

  def top_nav_about_active
    content_for :top_nav_about_current do
      top_nav_current_link_class
    end
  end

  def top_nav_dashboard_active
    content_for :top_nav_dashboard_current do
      top_nav_current_link_class
    end
  end

  def top_nav_course_catalog_active
    content_for :top_nav_course_catalog_current do
      top_nav_current_link_class
    end
  end

  def top_nav_current_classes_active
    content_for :top_nav_current_classes_current do
      top_nav_current_link_class
    end
  end

  def top_nav_my_tutor_active
    content_for :top_nav_my_tutor_current do
      top_nav_current_link_class
    end
  end

  def top_nav_help_active
    content_for :top_nav_help_current do
      top_nav_current_link_class
    end
  end

  def top_nav_home_page_background
    content_for :top_nav_class do
      "home-page "
    end
  end

protected

  def top_nav_render(text, options={})
    partial = "layouts/application_top_nav_link"

    target_text           = text
    target_image          = options.fetch(:target_image, "")
    target_id             = "top-nav-#{text.downcase.tr(' ', '-')}-link"
    target_path           = options.fetch(:target_path) { send("#{text.downcase.tr(' ', '_')}_page_path") }
    target_current_symbol = "top_nav_#{text.downcase.tr(' ', '_')}_current".to_sym

    render partial: partial,
           locals:  { target_text:           target_text,
                      target_image:          target_image,
                      target_id:             target_id,
                      target_path:           target_path,
                      target_current_symbol: target_current_symbol }
  end

  def top_nav_current_link_class
    "current "
  end

  def salutation(user)
    return "Welcome, #{user.casual_name}" if user
  end

  def account_bar_transparent
    content_for :account_bar_class do
      "transparent "
    end
  end
end
