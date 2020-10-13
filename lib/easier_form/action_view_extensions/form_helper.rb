module EasierForm
  module ActionViewExtensions
    module FormHelper

      # easier_form_for tag
      def easier_form_for(record, options = {}, &block)
        options[:builder] ||= EasierForm::FormBuilder
        options[:html] ||= {}
        #TODO 表单验证
        if options[:html].key?(:class)
          options[:html][:class] = [EasierForm.form_class, options[:html][:class]].compact
        else
          options[:html][:class] = [EasierForm.form_class, EasierForm.default_form_class, easier_form_css_class(record, options)]
        end

        with_simple_form_field_error_proc do
          # 调用form_for的构造方法
          form_for(record, options, &block)
        end
      end


      # easier form class获取
      def easier_form_css_class(record, options)
        options[:html] ||= {}
        as = options[:as]
        html_options = options[:html]
        if html_options.key?(:class)
          html_options[:class]
        elsif record.is_a?(String) || record.is_a?(Symbol)
          as || record
        else
          record = record.last if record.is_a?(Array)
          # 判断是否是新规
          action = record.respond_to?(:persisted?) && record.persisted? ? :edit : :new
          # 如果as存在则，return的class为 "#{action}_#{as}"
          # 否则则为"#{action}_#{ModelName}"
          as ? "#{action}_#{as}" : dom_class(record, action)
        end
      end

      private
      def with_simple_form_field_error_proc
        default_field_error_proc = ::ActionView::Base.field_error_proc
        begin
          ::ActionView::Base.field_error_proc = EasierForm.error_fields_proc
          yield
        rescue
          ::ActionView::Base.field_error_proc = default_field_error_proc
        end
      end
    end
  end
end

ActiveSupport.on_load :action_view do
  include EasierForm::ActionViewExtensions::FormHelper
end