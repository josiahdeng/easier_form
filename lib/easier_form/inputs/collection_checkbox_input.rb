module EasierForm
  module Inputs
    class CollectionCheckboxInput < CollectionRadioButtonInput
      protected

      def item_wrapper_class
        "checkbox"
      end

    end
  end
end