module EasierForm
  module Inputs
    class CollectionInput < Base

      BASIC_OBJECT_CLASSES = [String, Integer, Float, NilClass, Symbol, TrueClass, FalseClass]
      BASIC_OBJECT_CLASSES.push(Fixnum, Bignum) unless 1.class == Integer

      def self.boolean_collection
        i18n_cache :boolean_collection do
          [ [I18n.t(:"easier_form.yes", default: 'Yes'), true],
            [I18n.t(:"easier_form.no", default: 'No'), false] ]
        end
      end

      def input_options
        options = super

        options[:include_blank] = true unless skip_include_blank?
        translate_option options, :prompt
        translate_option options, :include_blank

        options
      end
      private
      def collection
        @collection  ||= begin
                           collection = options.delete(:collection) || self.class.boolean_collection
                           collection.respond_to?(:call) ? collection.call : collection.to_a
        end
      end

      def detect_collection_methods
        value_method,  label_method = options.delete(:value_method), options.delete(:label_method)
        unless value_method && label_method
          common_method_for = detect_common_collection_methods
          label_method ||= common_method_for[:label]
          value_method ||= common_method_for[:value]
        end
        [label_method, value_method]
      end

      def detect_common_collection_methods(collection_classes = detect_collection_classes)
        translated_collection = translation_collection if collection_classes == [Symbol]

        if translated_collection || collection_classes.include?(Array)
          {label: :first, value: :second}
        elsif collection_includes_basic_objects?(collection_classes)
          { label: :to_s, value: :to_s }
        else
          detect_method_from_class(collection_classes)
        end
      end

      #查看collection中的类型
      def detect_collection_classes(some_collection = collection)
        some_collection.map(&:class).uniq
      end

      def translation_collection
        if translated_collection = translation_html_namespace(:options)
          @collection = collection.map do |key|
            html_key = "#{key}_html".to_sym
            if translated_collection[html_key]
              [translated_collection[html_key].html_safe || key, key.to_s]
            else
              [translated_collection[key] || key, key.to_s]
            end
          end
          true
        end
      end

      def collection_includes_basic_objects?(collection_classes)
        (collection_classes & BASIC_OBJECT_CLASSES).any?
      end

      def detect_method_from_class(collection_classes)
        sample = collection.first || collection.last
        {
            label: EasierForm.collection_label_methods.find { |m| sample.respond_to?(m) },
            value: EasierForm.collection_value_methods.find { |m| sample.respond_to?(m) }
        }
      end

      def skip_include_blank?
        (options.keys & %i[prompt include_blank default selected]).any?
      end

      def translate_option(options, key)
        if options[key] == :translate
          namespace = key.to_s.pluralize

          options[key] = translation_html_namespace(namespace, true)
        end
      end
    end
  end
end
