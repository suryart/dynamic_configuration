require 'blankslate'

module DynamicConfiguration
  def self.create(const_name, config_file_name)
    ConfigFactory.new.create_config(const_name, config_file_name)
  end
  
  private

  class ConfigFactory   
    def create_config(const_name, config_file_name)
      setup_config(const_name, config_file_name)
      load_main_configuration_files
      load_per_environment_configuration_files if @rails_loaded
      load_local_configuration_files
      finalize_config
      @config
    end

    private
    
    def setup_config(const_name, config_path)
      @const_name  = const_name
      @config_path = Pathname.new(config_path)
      @config      = Config.new(@const_name, @config_path)

      Object.const_set @const_name, @config
    end

    def load_main_configuration_files
      @config_path.entries.each do |mod_file|
        next if ["..", "."].include?(mod_file.basename.to_s)
        mod_file = @config_path + mod_file
        next unless mod_file.file? && mod_file.basename.to_s != "#{@const_name.to_s.downcase}.rb"
        @config.load_module(mod_file)
      end
    end

    def load_per_environment_configuration_files
      @config_path.entries.each do |directory|
        next if ["..", "."].include?(directory.basename.to_s)
        directory = @config_path + directory
        next unless directory.directory? && Rails.env == directory.basename.to_s

        directory.entries.each do |mod_file|
          mod_file = directory + mod_file
          next unless mod_file.file?
          @config.load_module(mod_file)
        end
      end
    end

    def load_local_configuration_files
      local_settings_exist = FileTest.directory?(@config_path.to_s + "/local")
      rails_test_env = @rails_loaded && Rails.env == 'test'
      return if !local_settings_exist || rails_test_env

      local_mod_files_dir = @config_path + Pathname.new("local/")
      local_mod_files_dir.entries.each do |mod_file|
        next if ["..", "."].include?(mod_file.basename.to_s)
        mod_file = local_mod_files_dir + mod_file
        next unless mod_file.file?
        @config.load_module(mod_file)
      end
    end

    def finalize_config
      @config.freeze

      if Object.instance_eval { const_defined?(:Rails) }
        ::ActiveSupport::Dependencies.autoload_paths << @config_path.to_s
        ::ActiveSupport::Dependencies.explicitly_unloadable_constants << @const_name.to_s
      end
    end
  end

  class Config < ::BlankSlate    
    def initialize(const_name, config_path)
      @const_name, @config_path = const_name, config_path
    end

    def load_module(file_pathname)
      mod_name = file_pathname.basename.to_s[0..-4]

      @modules ||= {}
      @modules[mod_name.intern] ||= Submodule.new
      @modules[mod_name.intern].instance_eval(::IO.read(file_pathname.to_s))

      @settings ||= {}
      @settings[mod_name.intern] ||= Settings.new(@const_name, mod_name, @modules[mod_name.intern].settings)
    end

    def method_missing(name, *args, &block)
      unless @settings && @settings[name]
        raise MissingSubmoduleException.new("No configuration defined for a '#{name}' submodule")
      end

      @settings[name]
    end
  end

  class Submodule < ::BlankSlate
    attr_accessor :settings

    def initialize
      @settings = {}
    end

    def method_missing(name, value)
      @settings[name] = value
      @settings[name].freeze
    end
  end

  class Settings < ::BlankSlate
    def initialize(const_name, module_name, settings)
      @const_name = const_name
      @module_name = module_name
      @settings = settings
    end

    def method_missing(name, *args)
      @settings.fetch(name) { raise MissingSettingException.new("Setting '#{@const_name}.#{@module_name}.#{name}' is not defined") }
    end
  end

  class MissingSubmoduleException < StandardError; end
  class MissingSettingException < StandardError; end
end
