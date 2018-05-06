module HashExtension
	## Convert keys to symbols in Hash
	def keys_to_sym
		return self.map do |key, val|
			new_key = key.is_a?(String) ? key.to_sym      : key
			new_val = val.is_a?(Hash)   ? val.keys_to_sym : val
			next [new_key, new_val]
		end .to_h
	end
end

class Hash
	include HashExtension
end
