module EasierForm
  module Inputs
    class FileInput < Base
      def input(wrapper_options = nil)
        merge_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        @builder.file_field(attribute_name, merge_input_options)
      end
    end
  end
end