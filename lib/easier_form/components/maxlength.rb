module EasierForm
  module Components
    module Maxlength
      def maxlength(wrapper_option = nil)
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit
        nil
      end

      def maximum_length_from_validation
        maxlength = options[:maxlength]
        if maxlength.is_a?(String) || maxlength.is_a?(Integer)
          maxlength
        end
      end
    end
  end
end