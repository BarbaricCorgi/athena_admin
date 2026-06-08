require "rails/generators/base"

module AthenaAdmin
  module Generators
    # Wires the Athena (Ember) theme into a host ActiveAdmin 4 app:
    #   - vendors the token/component CSS into app/assets/tailwind (out of the served path)
    #   - imports it into the AA tailwind build
    #   - registers the gem's views as a tailwind content source (so partial classes scan)
    #   - copies self-hosted fonts to public/athena-fonts
    class InstallGenerator < Rails::Generators::Base
      desc "Install the Athena (Ember) theme into this ActiveAdmin 4 app."

      AA_TW_SRC = "app/assets/tailwind/active_admin.css".freeze
      TW_CONF   = "tailwind-active_admin.config.js".freeze

      def vendor_theme_css
        css = AthenaAdmin::Engine.root.join("app/assets/stylesheets/athena_admin.css").read
        create_file "app/assets/tailwind/athena_admin.css", css
      end

      def import_into_build
        unless File.exist?(AA_TW_SRC)
          say "Skipped @import: #{AA_TW_SRC} not found — run ActiveAdmin's tailwind setup first.", :yellow
          return
        end
        import_line = %(@import "./athena_admin.css";\n)
        return if File.read(AA_TW_SRC).include?(import_line)
        inject_into_file AA_TW_SRC, import_line, after: %(@import "tailwindcss";\n)
      end

      def add_view_content_source
        return unless File.exist?(TW_CONF)
        return if File.read(TW_CONF).include?("athena_admin")
        snippet = "    `${execSync('bundle show athena_admin', { encoding: 'utf-8' })" \
                  ".trim().split(/\\r?\\n/).pop()}/app/views/**/*.{erb,html,arb,rb}`,\n"
        inject_into_file TW_CONF, snippet, after: "content: [\n"
      end

      def copy_fonts
        src = AthenaAdmin::Engine.root.join("app/assets/fonts/athena_admin")
        src.children.select { |c| c.to_s.end_with?(".woff2") }.sort.each do |path|
          create_file "public/athena-fonts/#{path.basename}", File.binread(path)
        end
      end

      def done
        say "✓ Athena installed. Rebuild CSS: `yarn build:css` (or `bin/rails css:build`).", :green
      end
    end
  end
end
