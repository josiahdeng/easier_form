module EasierForm
  module Inputs
    class CollectionSelectInput < CollectionInput
      def input(wrapper_options = nil)
        label_method, value_method = detect_collection_methods

        merge_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        @builder.collection_select(
            attribute_name, collection, value_method, label_method,
            input_options, merge_input_options
        )
      end
    end
  end
end