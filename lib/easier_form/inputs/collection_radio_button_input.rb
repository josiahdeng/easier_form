module EasierForm
  module Inputs
    class CollectionRadioButtonInput < CollectionInput
      def input(wrapper_options = nil)
        label_method, value_method = detect_collection_methods
        merge_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        @builder.send(:"collection_#{input_type}", attribute_name,
                      collection, value_method, label_method, input_options,
                      merge_input_options)
      end

      def input_options
        options = super
        apply_default_collection_options!(options)
        options
      end

      protected

      def apply_default_collection_options!(options)
        options[:item_wrapper_tag] ||= options.fetch(:item_wrapper_tag, EasierForm.item_wrapper_tag)
        options[:item_wrapper_class] = [
            item_wrapper_class, options[:item_wrapper_class], EasierForm.item_wrapper_class
        ].compact.presence if EasierForm.include_default_input_wrapper_class

        options[:collection_wrapper_tag] ||= options.fetch(:collection_wrapper_tag, EasierForm.collection_wrapper_tag)
        options[:collection_wrapper_class] = [
            options[:collection_wrapper_class], EasierForm.collection_wrapper_class
        ].compact.presence
      end

      def item_wrapper_class
        "radio"
      end

    end
  end
end