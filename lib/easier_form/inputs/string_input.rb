module EasierForm
  module Inputs
    class StringInput < Base
      def input(wrapper_options = nil)
        unless string?
          input_html_classes.unshift("string")
        end
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        @builder.text_field(attribute_name, merged_input_options)
      end

      private

      def string?
        input_type == :string || input_type == :citext
      end
    end
  end
end