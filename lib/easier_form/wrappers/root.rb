module EasierForm
  module Wrappers
    class Root < Many
      attr_reader :options
      def initialize(*args)
        super(:wrapper, *args)
        @options = @default.except(:tag, :class, :error_class, :hint_class)
      end

      def render(input)
        input.options.reverse_merge!(@options)
        super
      end

      def html_classes(input, options)
        css = options[:wrapper_class] ? Array(options[:wrapper_class]) : @default[:class]
        css += EasierForm.additional_classes_for(:wrapper) do
          input.additional_classes
        end
        css
      end
    end
  end
end