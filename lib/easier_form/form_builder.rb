require 'easier_form/map_type'

module EasierForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    extend MapType
    include EasierForm::Inputs

    ACTIONS = {
        'create' => 'new',
        'update' => 'edit'
    }

    map_type :string, to: EasierForm::Inputs::StringInput
    map_type :boolean, to: EasierForm::Inputs::BooleanInput
    map_type :radio_buttons, to: EasierForm::Inputs::CollectionRadioButtonInput
    map_type :checkboxes, to: EasierForm::Inputs::CollectionCheckboxInput
    map_type :select, to: EasierForm::Inputs::CollectionSelectInput

    attr_reader :template, :object_name, :object, :wrapper

    def initialize(*)
      super
      @object = convert_to_model(@object)
      @defaults = options[:defaults]
      @wrapper  = EasierForm.wrapper(options[:wrappers] || EasierForm.default_wrapper)
    end

    # use <%= f.input :field_name %> get your input
    def input(attribute_name, options = {}, &block)
      input = find_input(attribute_name, options, &block)
      wrapper = find_wrapper(input.input_type, options)
      wrapper.render(input)
    end

    alias :attribute :input

    def lookup_model_names
      @lookup_model_names ||= begin
                                child_index = options[:child_index]
                                names = object_name.to_s.scan(/(?!\d)\w+/).flatten
                                names.delete(child_index) if child_index
                                names.each { |name| name.gsub!('_attributes', '') }
                                names.freeze
                              end
    end

    def lookup_action
      @lookup_action ||= begin
                           action = template.controller && template.controller.action_name
                           return unless action
                           action = action.to_s
                           ACTIONS[action] || action
                         end
    end

    private

    def find_input(attribute_name, options, &block)
      column = find_attribute_column(attribute_name)
      input_type = default_input_type(attribute_name, column, options)
      find_mapping(input_type).new(self, attribute_name, column, input_type, options)
    end

    #get column infos
    def find_attribute_column(attribute_name)
      if @object.respond_to?(:type_for_attribute) && @object.has_attribute?(attribute_name)
        @object.type_for_attribute(attribute_name.to_s)
      elsif @object.respond_to?(:column_for_attribute) && @object.has_attribute?(attribute_name)
        @object.column_for_attribute(attribute_name)
      end
    end

    def default_input_type(attribute_name, column, options)
      return options[:as].to_sym if options[:as]
      custom_type = find_custom_type(attribute_name.to_s) and return custom_type
      return :select if options[:collection]
      type = column.try(:type)
      case type
      when :timestamp
        :datetime
      when /(?:\b|\W|\_)password(?:\b|\W|\_)/
        :password
      else
        type
      end
    end

    def find_custom_type(attribute_name)
      EasierForm.input_mappings.find { |match, type|
        attribute_name =~ match
      }.try(:last) if EasierForm.input_mappings
    end

    def find_mapping(input_type)
      # discovery_cache[input_type] ||=
          if mapping = self.class.mappings[input_type]
            mapping
          else
            camelized = "#{input_type.to_s.camelize}Input"
      # attempt_mapping_with_custom_namespace(camelized) ||
      attempt_mapping(camelized, Object) ||
          attempt_mapping(camelized, self.class) ||
          raise("No input found for #{input_type}")
      end
    end

    # return Mapping or At::Mapping
    def attempt_mapping(mapping, at)
      # return if SimpleForm.inputs_discovery == false && at == Object

      begin
        at.const_get(mapping)
      rescue NameError => e
        raise if e.message !~ /#{mapping}$/
      end
    end

    def find_wrapper_mapping(input_type)
      if options[:wrapper_mappings] && options[:wrapper_mappings][input_type]
        options[:wrapper_mappings][input_type]
      else
        EasierForm.wrapper_mappings && EasierForm.wrapper_mappings[input_type]
      end
    end

    def find_wrapper(input_type, options)
      if name = options[:wrapper] || find_wrapper_mapping(input_type)
        name.respond_to?(:render) ? name : EasierForm.wrapper(name)
      else
        wrapper
      end
    end
  end
end
