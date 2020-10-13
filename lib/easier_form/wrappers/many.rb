module EasierForm
  module Wrappers
    class Many
      attr_reader :components, :default, :namespace

      def initialize(namespace, components, default={})
        @namespace = namespace
        @components = components
        @default = default
        @default[:tag] = 'div' unless @default.key?(:tag)
        @default[:class] = Array(@default[:class])
      end

      def render(input)
        content = "".html_safe
        options = input.options
        components.each do |component|
          next if options[component.namespace] == false
          rendered = component.render(input)
          content.safe_concat rendered.to_s if rendered
        end

        wrap(input, options, content)
      end

      private

      def wrap(input, options, content)
        return content if options[namespace] == false
        return if options[:unless_blank] && content.empty?

        tag = (namespace && options["#{namespace}_tag"]) || @default[:tag]
        return content unless tag

        klass = html_classes(input, options)
        opts = html_options(options)

        opts[:class] = (klass << opts[:class]).join(" ").strip if klass.present?
        input.template.content_tag(tag, content, opts)
      end

      def html_options(options)
        (@default[:html] || {}).merge(options["#{namespace}_html"] || {})
      end

      def html_classes(input, options)
        @default[:class].dup
      end
    end
  end
end