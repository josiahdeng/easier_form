module EasierForm
  module Inputs
    class PasswordInput < Base

      def input(wrapper_options = nil)
        @builder.password_field(attribute_name, input_html_options)
      end
    end
  end
end