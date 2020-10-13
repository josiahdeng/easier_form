module EasierForm
  class Railtie < ::Rails::Railtie
    config.eager_load_namespaces << EasierForm
  end
end
