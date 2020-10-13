module EasierForm
  module Inputs
    class BooleanInput < Base
      def input(wrapper_options = nil)
        merge_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        @builder.check_box(attribute_name, merge_input_options, checked_value, unchecked_value)
      end

      def checked_value
        options.fetch("checked_value", "1")
      end

      def unchecked_value
        options.fetch("unchecked_value", "0")
      end
    end
  end
end