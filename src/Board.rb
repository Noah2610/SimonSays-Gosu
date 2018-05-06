class Board
	def initialize
		@settings              = SETTINGS.board
		@fields                = nil
		@fields_settings       = SETTINGS.fields
		@play_length           = @settings[:starting_play_length]
		@current_playing_order = nil
		@current_playing_index = nil
		@recording_fields      = []
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
		field = @fields.detect do |f|
			next f  if (f.key? char)
		end
		if (!!field)
			@recording_fields << field
			deactivate_fields
			field.activate!
			handle_recording_finished  if (@recording_fields.size >= @play_length)
		end
	end

	def handle_recording_finished
		if (@current_playing_order == @recording_fields)
			@recording_fields = []
			@play_length += 1
			GAME.handle_successful_recording
		else
			GAME.game_over
		end
	end

	def deactivate_fields
		@fields.each &:deactivate!
	end

	def update
		deactivate_fields  if (GAME.get_tick % @settings[:deactivate_interval] == 0)
		if (GAME.playing?)
			play_field  if (GAME.get_tick % @settings[:play_interval] == 0)
		end
	end

	def play_field
		start_playing  if (@current_playing_index.nil?)
		@current_playing_order[@current_playing_index].activate!
		@current_playing_index += 1
		stop_playing   if (@current_playing_index == @current_playing_order.size)
	end

	def start_playing
		@current_playing_order = get_random_playing_order
		@current_playing_index = 0
	end

	def stop_playing
		@current_playing_index = nil
		GAME.set_state :recording
	end

	def get_random_playing_order
		return @play_length.times.map do
			next @fields.sample
		end
	end

	def draw
		draw_fields
	end

	def draw_fields
		@fields.each &:draw
	end
end
