require 'easier_form/i18n_cache'
module EasierForm
  module Inputs
    class Base
      include ERB::Util

      include ActionView::Helpers::TranslationHelper

      extend I18nCache

      # helper methods
      include EasierForm::Helpers::Required
      include EasierForm::Helpers::Validators

      include EasierForm::Components::Label
      include EasierForm::Components::Maxlength
      include EasierForm::Components::Error

      attr_reader :attribute_name, :column, :input_type, :reflection,
                  :options, :input_html_options, :input_html_classes, :html_classes

      delegate :template, :object, :object_name, :lookup_model_names, :lookup_action, to: :@builder

      class_attribute :default_options
      self.default_options = {}

      def initialize(builder, attribute_name, column, input_type, options={})
        options = options.dup
        @builder = builder
        @attribute_name = attribute_name
        @column = column
        @input_type = input_type
        @options = options.reverse_merge(self.class.default_options)
        @html_classes = EasierForm.additional_classes_for(:input) { additional_classes }
        @required = calculate_required

        @input_html_classes = @html_classes.dup

        input_html_classes = self.input_html_classes

        if EasierForm.input_class && input_html_classes.any?
          input_html_classes << EasierForm.input_class
        end

        @input_html_options = html_options_for("input", input_html_classes)
      end


      def input(wrapper_options = nil)
        raise NotImplementedError
      end

      def input_options
        options
      end

      def additional_classes
        @additional_classes ||= [input_type].compact
      end

      def limit
        column.limit
      end

      def reflection_or_attribute_name
        @reflection_or_attribute_name ||= reflection ? reflection.name : attribute_name
      end

      def html_options_for(namespace, css_classes)
        html_options = options["#{namespace}_html"]
        html_options ||= {}
        css_classes << html_options[:class] if html_options.key?(:class)
        html_options[:class] = css_classes if css_classes.present?
        html_options
      end

      # wrapper with options merge options
      def merge_wrapper_options(options, wrapper_options)
        if wrapper_options
          wrapper_options = set_input_classes(wrapper_options)

          wrapper_options.merge(options) do |key, old_val, new_val|
            case key
            when "class"
              Array[old_val] + Array[new_val]
            when "data", "aria"
              old_val.merge(new_val)
            else
              new_val
            end
          end
        else
          options
        end
      end

      def set_input_classes(wrapper_options)
        wrapper_options = wrapper_options.dup
        error_class = wrapper_options.delete(:error_class)
        valid_class = wrapper_options.delete(:valid_class)

        wrapper_options
      end

      def translation_html_namespace(namespace, default = '')
        model_names = lookup_model_names.dup
        lookups = []

        while model_names.present?
          join_model_names = model_names.join(".")
          model_names.shift

          lookups << :"#{join_model_names}.#{lookup_action}.#{reflection_or_attribute_name}"
          lookups << :"#{join_model_names}.#{reflection_or_attribute_name}"
        end
        lookups << :"defaults.#{lookup_action}.#{reflection_or_attribute_name}"
        lookups << :"defaults.#{reflection_or_attribute_name}"
        lookups << default
        I18n.t(lookups.shift, scope: :"#{i18n_scope}.#{namespace}", default: lookups).presence
      end

      def i18n_scope
        EasierForm.i18n_scope
      end
    end
  end
end