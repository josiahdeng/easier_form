module EasierForm
  module Wrappers
    class Leaf
      attr_reader :namespace

      def initialize(namespace, options = {})
        @namespace = namespace
        @options = options
      end

      def render(input)
        method = input.method(@namespace)
        method.call(@options)
      end
    end
  end
end