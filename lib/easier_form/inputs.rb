module EasierForm
  module Inputs
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :StringInput
    autoload :PasswordInput
    autoload :FileInput
    autoload :BooleanInput
    autoload :CollectionInput
    autoload :CollectionRadioButtonInput
    autoload :CollectionCheckboxInput
    autoload :CollectionSelectInput
  end
end