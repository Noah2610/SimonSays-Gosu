class Game < Gosu::Window
	def initialize
		@settings = SETTINGS.game
		@size     = SETTINGS.window(:size)
		@tick     = 0
		super @size[:width], @size[:height]
		self.caption = 'A Simon-Says clone'
	end

	def init
		@board = Board.new
	end

	def button_down key_id
		exit  if (Gosu::KB_ESCAPE == key_id)
		char = Gosu.button_id_to_char key_id
		@board.handle_input char.upcase
	end

	def get_size
		return @size
	end

	def update
		@board.deactivate_fields  if (@tick % @settings[:deactivate_interval] == 0)
		@tick += 1
	end

	def draw
		draw_background
		draw_board
	end

	def draw_background
		Gosu.draw_rect(
			0, 0,
			@size[:width], @size[:height],
			@settings[:background_color],
			@settings[:z_index]
		)
	end

	def draw_board
		@board.draw
	end
end

SETTINGS = Settings.new
GAME     = Game.new
GAME.init
GAME.show
