module EasierForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "copy easier form config to your config dir."
      source_root File.expand_path("../templates", __FILE__)

      def copy_config
        template "config/initializers/easier_form_bootstrap.rb"

        directory "config/locales"
      end
    end
  end
end