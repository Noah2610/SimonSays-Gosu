class Board
	def initialize
		@settings        = SETTINGS.board
		@fields          = nil
		@fields_settings = SETTINGS.fields
		init_fields
	end

	def init_fields
		position = get_field_starting_position
		@fields = @fields_settings[:instances].map.with_index do |hash, index|
			name     = hash[0]
			settings = hash[1]
			settings_merged = @fields_settings[:defaults].merge settings
			case index
			when 0
				# Do nothing
			when 1, 3
				position = {
					x: (position[:x] + settings_merged[:size][:width] + @settings[:field_padding]),
					y: position[:y]
				}
			when 2
				position = {
					x: (position[:x] - settings_merged[:size][:width]  - @settings[:field_padding]),
					y: (position[:y] + settings_merged[:size][:height] + @settings[:field_padding]),
				}
			end
			nex = Field.new(
				name:     name,
				position: position,
				settings: settings_merged
			)
			next nex
		end
	end

	def get_field_starting_position
		window_size = GAME.get_size
		position    = {
			x: ((window_size[:width] * 0.5)  - @fields_settings[:defaults][:size][:width]  - (@settings[:field_padding] * 0.5)).floor,
			y: ((window_size[:height] * 0.5) - @fields_settings[:defaults][:size][:height] - (@settings[:field_padding] * 0.5)).floor
		}
		return position
	end

	def handle_input char
		@fields.each do |field|
			if (field.key? char)
				deactivate_fields
				field.activate!
				break
			end
		end
	end

	def deactivate_fields
		@fields.each &:deactivate!
	end

	def draw
		draw_fields
	end

	def draw_fields
		@fields.each &:draw
	end
end
