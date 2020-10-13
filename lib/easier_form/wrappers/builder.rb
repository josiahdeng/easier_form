module EasierForm
  module Wrappers
    class Builder
      def initialize(options)
        @options = options
        @components = []
      end

      def use(name, options = {})
        if options && wrapper = options[:wrap_with]
          @components << Single.new(name, wrapper, options.except(:wrap_with))
        else
          @components << Leaf.new(name, options)
        end
      end

      def optional(name, options = {})
        @options[name] = false
        use(name, options)
      end

      def to_a
        @components
      end
    end
  end
end