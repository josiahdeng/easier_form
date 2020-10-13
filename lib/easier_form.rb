require 'action_view'
require 'action_pack'
require 'easier_form/action_view_extensions/form_helper'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/reverse_merge'
module EasierForm
  extend ActiveSupport::Autoload

  autoload :Helpers
  autoload :Wrappers

  eager_autoload do
    autoload :Components
    autoload :FormBuilder
    autoload :Inputs
  end

  self.eager_load! do
    super
    EasierForm::Inputs.eager_load!
    EasierForm::Components.eager_load!
  end
  @@configured = false
  def self.configured?
    @@configured
  end

  #easier form class
  mattr_accessor :form_class
  @@form_class = :easier_form

  # no class attributes class
  mattr_accessor :default_form_class
  @@default_form_class = nil

  mattr_accessor :wrapper_mappings
  @@wrapper_mappings = nil

  mattr_accessor :input_class
  @@input_class = nil

  mattr_accessor :error_fields_proc
  @@error_fields_proc = proc do |html_tag, instance_tag|
    html_tag
  end

  mattr_accessor :generate_additional_classes_for
  @@generate_additional_classes_for = %i[wrapper label input]

  mattr_accessor :default_wrapper
  @@default_wrapper = :default
  @@wrappers = {}

  mattr_accessor :input_mappings
  @@input_mappings = {}

  mattr_accessor :i18n_scope
  @@i18n_scope = :easier_form

  mattr_accessor :required_by_default
  @@required_by_default = true

  mattr_accessor :translate_labels
  @@translate_labels = true

  mattr_accessor :label_text
  @@label_text = ->(label_text, required, label_present){"#{required} #{label_text}"}

  mattr_accessor :error_method
  @@error_method = :first

  mattr_accessor :collection_label_methods
  @@collection_label_methods = %i[title to_label to_s to_name]

  mattr_accessor :collection_value_methods
  @@collection_value_methods = %i[to_value id to_s]

  mattr_accessor :item_wrapper_tag
  @@item_wrapper_tag = :span

  mattr_accessor :item_wrapper_class
  @@item_wrapper_class = nil

  mattr_accessor :include_default_input_wrapper_class
  @@include_default_input_wrapper_class = true

  mattr_accessor :collection_wrapper_tag
  @@collection_wrapper_tag = nil

  mattr_accessor :collection_wrapper_class
  @@collection_wrapper_class = nil

  def self.wrapper(name)
    @@wrappers[name.to_s] or raise WrapperNotFound, "this wrappers not exist, #{name}"
  end

  class WrapperNotFound < StandardError
  end

  def self.wrappers(*args, &block)
    if block_given?
      options                 = args.extract_options!
      name                    = args.first || :default
      @@wrappers[name.to_s]   = build(options, &block)
    else
      @@wrappers
    end
  end

  def self.build(options)
    options[:tag] = 'div' unless options.key?(:tag)
    builder = EasierForm::Wrappers::Builder.new(options)
    yield builder
    EasierForm::Wrappers::Root.new(builder.to_a, options)
  end

  # use config file
  def self.setup(&block)
    @@configured = true
    yield self
  end

  def self.additional_classes_for(component)
    generate_additional_classes_for.include?(component) ? yield : []
  end
end

require 'easier_form/railtie'if defined?('rails')
