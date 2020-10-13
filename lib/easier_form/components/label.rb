module EasierForm
  module Components
    module Label
      extend ActiveSupport::Concern

      module ClassMethods
        def translate_required_html
          i18n_cache :translate_required_html do
            I18n.t(:"required.html", scope: i18n_scope, default:
                %(<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr>))
          end
        end

        def translate_required_text
          I18n.t(:"required.text", scope: i18n_scope, default: "required")
        end

        def translate_required_mark
          I18n.t(:"required.mark", scope: i18n_scope, default: "*")
        end

        private

        def i18n_scope
          EasierForm.i18n_scope
        end
      end

      def label(wrapper_options = nil)
        label_options = merge_wrapper_options(label_html_options, wrapper_options)
        generate_label_for_attribute? ? @builder.label(label_target, label_text, label_options) : template.label_tag(nil, label_text, label_options)
      end

      def label_html_options
        label_html_classes = EasierForm.additional_classes_for(:label) do
          [input_type].compact
        end

        label_options = html_options_for(:label, label_html_classes)
        label_options[:for] = options[:input_html][:id] if options.key?(:input_html) && options[:input_html].key?(:id)

        label_options
      end

      def label_target
        attribute_name
      end

      def label_text
        method = options[:label_text] || EasierForm.label_text
        method = EasierForm.label_text unless method.respond_to?(:call)
        method.call(html_escape(raw_label_text), required_label_text, options[:label].present?).strip.html_safe
      end

      protected
      def generate_label_for_attribute?
        true
      end

      def raw_label_text
        options[:label] || label_translation
      end

      def required_label_text #:nodoc:
        required_field? ? self.class.translate_required_html.dup : ''
      end

      def label_translation
        if EasierForm.translate_labels && (translated_label = translation_html_namespace(:labels))
          translated_label
        elsif object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(reflection_or_attribute_name.to_s)
        else
          attribute_name.to_s.humanize
        end
      end
    end
  end
end