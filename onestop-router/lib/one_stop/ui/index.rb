module OneStop
  module UI
    class Index < ActiveAdmin::Views::Pages::Index

      # Overrides:
      # https://github.com/gregbell/active_admin/blob/master/lib/active_admin/views/pages/base.rb#L57
      def build_page_content
        build_flash_messages
        div :id => "active_admin_content", :class => (skip_sidebar? ? "without_sidebar" : "with_sidebar") do
          build_sidebar unless skip_sidebar?
          build_main_content_wrapper
        end
      end
    end
  end
end
