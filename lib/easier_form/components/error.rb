module EasierForm
  module Components
    module Error
      def error(wrapper_options = nil)
        error_text if has_error?
      end

      def has_error?
        object_with_errors? || object.nil? && has_custom_error?
      end

      private

      def object_with_errors?
        object && object.respond_to?(:errors) && errors.present?
      end

      def errors
        @errors = (errors_for_attribute + errors_on_association).compact
      end

      def error_text
        text = has_custom_error? ? options[:error] : errors.send(error_method)
        "#{html_escape(options[:error_prefix])} #{html_escape(text)}".lstrip.html_safe
      end

      def errors_for_attribute
        object.errors[attribute_name] || []
      end

      def errors_on_association
        reflection ? object.errors[reflection.name] : []
      end

      def has_custom_error?
        options[:error].is_a?(String)
      end

      def error_method
        options[:error_method].is_a?(Symbol) ? options[:error_method] : EasierForm.error_method
      end
    end
  end
end