module EasierForm
  module Helpers
    module Required
      private
      def required_field?
        @required
      end

      def calculate_required
        if options[:required].present? && options[:required] == true
          true
        elsif has_validators?
          required_by_validators
        else
          required_by_default
        end
      end

      def required_by_validators
        (attribute_validators).any? {|v| v.kind == :presence && valid_validator?(v)}
      end

      def required_by_default
        EasierForm.required_by_default
      end

      def required_class
        required_field? ? :required : :optional
      end
    end
  end
end