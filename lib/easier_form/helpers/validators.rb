module EasierForm
  module Helpers
    module Validators
      def has_validators?
        @has_validators ||= attribute_name && object.class.respond_to?(:validators_on)
      end

      private

      def attribute_validators
        object.class.validators_on(attribute_name)
      end

      def valid_validator?(validator)
        !conditional_validators?(validator) && action_validator_match?(validator)
      end

      def conditional_validators?(validator)
        validator.options.include?(:if) or validator.options.include?(:unless)
      end

      def action_validator_match?(validator)
        return true unless validator.options.include?(:on)

        case validator.options[:on]
        when :save
          true
        when :create
          !object.persisted?
        when :update
          object.persisted?
        end
      end
    end
  end
end