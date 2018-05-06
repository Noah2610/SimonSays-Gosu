class Game < Gosu::Window
	def initialize
		@settings = SETTINGS.game
		@size     = SETTINGS.window(:size)
		@tick     = 0
		@state    = :playing
		@score    = 0
		@running  = false
		@font     = Gosu::Font.new 24
		super @size[:width], @size[:height]
		self.caption = 'A Simon-Says clone'
	end

	def init
		@board   = Board.new
		@running = true
	end

	def button_down key_id
		exit    if (Gosu::KB_ESCAPE == key_id)
		return  unless (running?)
		char = Gosu.button_id_to_char key_id
		@board.handle_input char.upcase  if (recording?)
	end

	def recording?
		return (@state == :recording)
	end

	def playing?
		return (@state == :playing)
	end

	def get_size
		return @size
	end

	def get_tick
		return @tick
	end

	def set_state state
		@state = state
	end

	def handle_successful_recording
		@score += 1
		set_state :playing
	end

	def game_over
		@board.deactivate_fields
		@running = false
	end

	def update
		return  unless (running?)
		@board.update
		@tick += 1
	end

	def running?
		return !!@running
	end

	def draw
		draw_background
		draw_board
		draw_score
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

	def draw_score
		@font.draw_rel(
			"Score: #{@score}",
			16, 16, 100,
			0, 0,
			1, 1,
			@settings[:font_color]
		)
	end
end

SETTINGS = Settings.new
GAME     = Game.new
GAME.init
GAME.show
