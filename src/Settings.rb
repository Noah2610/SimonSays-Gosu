class Settings
	def initialize file = DIR[:settings]
		@settings = nil
		load_settings_file file
	end

	def load_settings_file file
		abort "Settings file '#{file}' doesn't exist or is a directory. Exitting."  unless (File.file? file)
		try_to_load_settings_from_yaml_file file
		convert_settings_keys_to_symbols
	end

	def try_to_load_settings_from_yaml_file file
		begin
			@settings = YAML.load_file file
		rescue
			abort "Couldn't load settings from '#{file}'.\nIs it a YAML file?"
		end
	end

	def convert_settings_keys_to_symbols
		@settings = @settings.keys_to_sym
	end

	def get_setting key, target = nil
		key    = key
		target = target  unless (target.nil?)
		return nil  if (!@settings[key])
		if (!!target && val = @settings[key][target])
			ret = val
		else
			ret = @settings[key]
		end
		if (ret.is_a? Hash)
			return ret
		else
			return ret
		end
	end

	def method_missing meth, *args
		return get_setting meth, args[0]
	end
end
