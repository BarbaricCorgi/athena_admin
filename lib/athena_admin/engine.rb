module AthenaAdmin
  class Engine < ::Rails::Engine
    # Prepend the gem's view path so our partials (e.g. active_admin/_html_head)
    # take precedence over ActiveAdmin's same-path partials.
    initializer "athena_admin.prepend_views" do
      ActiveSupport.on_load(:action_controller_base) do
        prepend_view_path AthenaAdmin::Engine.root.join("app/views")
      end
    end
  end
end
