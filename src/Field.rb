class Field
	def initialize args = {}
		@font     = Gosu::Font.new 24
		@name     = args[:name]
		@position = args[:position]
		@settings = args[:settings]
		@active   = false
		init_settings
	end

	def init_settings
		@key          = (@settings[:key] || '').upcase
		@color        = @settings[:color]
		@size         = @settings[:size]
		@z_index      = @settings[:z_index]
		@active_color = @settings[:active_color]
	end

	def key? char
		return (char == @key)
	end

	def activate!
		@active = true
	end

	def deactivate!
		@active = false
	end

	def draw
		draw_body
		draw_key
	end

	def draw_body
		Gosu.draw_rect(
			@position[:x], @position[:y],
			@size[:width], @size[:height],
			get_color,
			@z_index
		)
	end

	def get_color
		return @color                  if (inactive?)
		return @color & @active_color  if (active?)
	end

	def active?
		return !!@active
	end

	def inactive?
		return !@active
	end

	def draw_key
		position = {
			x: (@position[:x] + (@size[:width]  * 0.5)).round,
			y: (@position[:y] + (@size[:height] * 0.5)).round
		}
		@font.draw_rel(
			@key,
			position[:x], position[:y], 100,
			0.5, 0.5,
			1, 1
		)
	end
end
