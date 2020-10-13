module EasierForm
  module Wrappers
    class Single < Many
      def initialize(namespace, wrapper_options = {}, options = {})
        @component = Leaf.new(namespace, options)
        super(namespace, [@component], wrapper_options)
      end

      def render(input)
        options = input.options
        if options[namespace] != false
          content = @component.render(input)
          wrap(input, options, content) if content
        end
      end

      private

      def html_options(options)
        %i[label input].include?(namespace) ? {}: super
      end
    end
  end
end