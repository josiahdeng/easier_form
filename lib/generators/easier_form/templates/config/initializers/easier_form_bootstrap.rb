EasierForm.setup do |config|
  config.wrappers :default do |b|
    b.optional :maxlength
    b.use :input
    b.use :error, wrap_with: {tag: "span"}
  end
end