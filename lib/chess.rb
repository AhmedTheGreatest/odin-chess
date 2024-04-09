# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require_relative 'board'
require_relative 'check_determination'
module Chess
  # This class represents the chess game
  class Chess
    attr_reader :current_turn, :history, :full_move_clock, :half_move_clock, :white_king_pos, :black_king_pos

    BACK_COMMAND = 'back'
    SAVE_COMMAND = 'save'

    def initialize
      @board = Board.new
      @current_turn = :white
      @history = []
      @half_move_clock = 0
      @full_move_clock = 0
      @white_check = false
      @black_check = false
      update_check_state
    end

    # Loads a game from a file
    def self.load_game(path)
      # If the file does not exist display an error
      unless File.exist?(path)
        puts "Error: File #{path} not found."
        return nil
      end

      # Opens the file and loads the object
      File.open(path, 'r') do |file|
        Marshal.load(file.read)
      end
    end

    def play
      # log_messages
      turn until game_end?
      @board.display
      display_game_end_msg
    end

    def self.from_fen(fen)
      game = Chess.new
      game.load_fen(fen)
      game
    end

    def load_fen(fen)
      @board = Board.from_fen(fen)
      fen_parts = fen.split(' ')
      turn = fen_parts[1] == 'w' ? :white : :black
      @current_turn = turn
      @half_move_clock = fen_parts[4].to_i
      @full_move_clock = fen_parts[5].to_i
      @history = []
      update_check_state
      en_passant_from_fen(fen)
    end

    def game_end?
      # TODO: Add Checkmate logic, Stalemate logic, and draw logic
      return :checkmate if checkmate?(:white) || checkmate?(:black)
      return :stalemate if stalemate?
      return :threefold_repetition if threefold_repetition?
      return :insufficient_material if insufficient_material?
      return :fifty_moves_rule if fifty_moves_rule?

      false
    end

    def switch_turn
      @current_turn = @current_turn == :white ? :black : :white
    end

    private

    # Serializes and saves a game into a file
    def save_game
      Dir.mkdir('games') unless Dir.exist?('games') # Creates a games directory unless it already exists

      File.open(available_file_name, 'w') do |file|
        file.write(Marshal.dump(self))
      end
    end

    # Returns the available game file name
    def available_file_name
      counter = 0
      loop do
        break unless File.exist?("games/game#{counter}.bin")

        counter += 1
      end
      "games/game#{counter}.bin"
    end

    def display_game_end_msg
      puts 'Game over!'.red
      winner = determine_winner
      case winner
      when :white
        puts 'White has won the game!'
      when :black
        puts 'Black has won the game!'
      when :stalemate
        puts 'The game is a STALEMATE :|'
      when :draw
        puts 'The game is a draw.'
      end
    end

    def determine_winner
      game_end_reason = game_end?
      case game_end_reason
      when :checkmate
        @current_turn
      when :stalemate
        :stalemate
      when :threefold_repetition, :insufficient_material, :fifty_moves_rule
        :draw
      end
    end

    def stalemate?
      # Check if the current player is stalemated
      # Stalemate occurs when the player is not in check, but they have no legal moves
      CheckDetermination.stalemate?(current_turn, @board)
    end

    def insufficient_material?
      # Check if the game has ended due to insufficient material on the board
    end

    def threefold_repetition?
      # Check if the game has ended due to threefold repetition of the same position
    end

    def fifty_moves_rule?
      # Check if the game has ended due to the fifty-move rule
      @half_move_clock >= 50
    end

    def checkmate?(color)
      CheckDetermination.checkmate?(color, @board)
    end

    def update_check_state
      @white_check = CheckDetermination.for?(:white, @board)
      @black_check = CheckDetermination.for?(:black, @board)
    end

    def en_passant_from_fen(fen)
      piece_notation = fen.split(' ')[3]
      return nil if piece_notation == '-'

      target_coords = find_cell(piece_notation) # Rank, file
      piece_coords = piece_from_target_square(target_coords)
      piece = @board.get(piece_coords)

      # Calculate last previous rank
      previous_rank = (piece_coords[0] == 4 ? 6 : 1) # Ranks start from the top starting from 0
      previous_coords = [previous_rank, piece_coords[1]]

      # Creating and appending last move to history for en passant
      previous_move = Move.new(previous_coords, piece_coords, piece)
      @history << previous_move
    end

    def piece_from_target_square(target_square)
      target_rank, target_file = target_square
      piece_rank = target_rank == 2 ? 3 : 4
      [piece_rank, target_file]
    end

    def turn
      system('clear')
      log_messages
      @board.display
      make_move
      switch_turn
    end

    def display_heading
      puts 'A Chess Game made by Ahmed Hannan'.red.bold.underline.italic
    end

    def log_messages
      display_heading
      puts
      puts "Full moves: #{@full_move_clock}".red.bold
      puts "Half moves: #{@half_move_clock}".red.bold
      puts 'White is in CHECK!'.red.bold if CheckDetermination.for?(:white, @board)
      puts 'Black is in CHECK!'.red.bold if CheckDetermination.for?(:black, @board)
      puts 'CHECKMATE for White!'.red.bold if checkmate?(:white)
      puts 'CHECKMATE for Black!'.red.bold if checkmate?(:black)
      puts
    end

    def make_move
      move = fetch_move
      handle_move_clock(move)
      move_piece(move)
      update_check_state
      update_history(move)
    end

    def fetch_move
      loop do
        source_position = fetch_square
        move = fetch_destination(source_position)
        return move unless move.nil?
      end
    end

    def handle_move_clock(move)
      handle_half_moves(move)
      handle_full_moves(move)
    end

    def handle_half_moves(move)
      @half_move_clock += 1
      @half_move_clock = 0 if move.is_a?(CaptureMove) || move.piece.is_a?(Pawn)
    end

    def handle_full_moves(move)
      @full_move_clock += 1 if move.turn == :black
    end

    def move_piece(move)
      @board.remove_piece(move.from)
      @board.remove_piece(move.captured_position) if move.is_a?(CaptureMove)

      if move.is_a?(CastleMove)
        @board.remove_piece(move.previous_rook_position)
        @board.set(move.new_rook_position, move.rook_piece)
      end

      @board.set(move.to, move.piece)
    end

    def update_history(move)
      move.piece.has_moved = true if move.piece.is_a?(King) || move.piece.is_a?(Rook)
      @history << move
    end

    def move_piece_custom_board(move, board)
      board.remove_piece(move.from)
      board.remove_piece(move.captured_position) if move.is_a?(CaptureMove)

      if move.is_a?(CastleMove)
        board.remove_piece(move.previous_rook_position)
        board.set(move.new_rook_position, move.rook_piece)
      end

      board.set(move.to, move.piece)
      board
    end

    def fetch_destination(source_position)
      loop do
        position = fetch_position('enter the destination of the piece you want to move (type \'back\' to go back):')
        return if position == BACK_COMMAND

        save_game if position == SAVE_COMMAND

        source_piece = @board.get(source_position)
        valid_moves = fetch_valid_moves(source_piece, source_position)
        valid_move = valid_moves.find { |move| move.to == position }
        return valid_move if allowed_move?(valid_move)

        puts 'Invalid move. Please choose a valid destination.'
      end
    end

    def allowed_move?(move)
      return false unless move

      return false if move_results_in_check?(move)

      true
    end

    def move_results_in_check?(move)
      board_copy = Marshal.load(Marshal.dump(@board))

      board_copy = move_piece_custom_board(move, board_copy)
      CheckDetermination.for?(move.turn, board_copy)
    end

    def fetch_valid_moves(piece, position)
      return piece.valid_moves(@board, position, @history.last) if piece.is_a?(Pawn)

      check = piece.color == :white ? @white_check : @black_check
      return piece.valid_moves(@board, position, check: check) if piece.is_a?(King)

      piece.valid_moves(@board, position)
    end

    def fetch_position(prompt)
      puts "#{@current_turn == :white ? 'White' : 'Black'} #{prompt}"
      input = fetch_valid_input
      return input if [BACK_COMMAND, SAVE_COMMAND].include?(input)

      find_cell(input)
    end

    def fetch_square
      loop do
        position = fetch_position('enter the position of the piece you want to move: (e4)')

        next if position == BACK_COMMAND

        if position == SAVE_COMMAND
          save_game
          next
        end

        if @board.board[position[0]][position[1]] && @board.board[position[0]][position[1]].color == @current_turn
          return position
        end

        puts 'Invalid move. Please choose a valid piece.'
      end
    end

    def fetch_valid_input
      input = nil
      loop do
        input = gets.chomp.downcase
        break if [BACK_COMMAND, SAVE_COMMAND].include?(input)
        break if input.length >= 2 && input.match?(/[a-zA-Z]/) && input.match?(/\d/)
      end
      input
    end

    def find_cell(input)
      characters = input.chars
      letter = find_valid_letter(characters)

      valid_rank = find_rank_from_notation(characters, letter)
      file = letter_to_number(letter)
      [valid_rank, file]
    end

    def find_valid_letter(characters)
      characters.find do |char|
        alphabetical?(char)
      end
    end

    def find_rank_from_notation(characters, file_letter)
      index = characters.find_index(file_letter)
      rank = characters[index + 1]
      unless numerical?(rank)
        puts 'Invalid notation'
        return nil
      end
      reverse_rank(rank.to_i - 1)
    end

    def reverse_rank(rank_index)
      7 - rank_index
    end

    def letter_to_number(char)
      return char.ord - 'a'.ord if char.match?(/[a-z]/i)

      nil # Return nil for non-letter characters
    end

    def alphabetical?(str)
      !!str.match(/^[[:alpha:]]+$/)
    end

    def numerical?(str)
      !!str.match?(/\A\d+\z/)
    end
  end
end
# rubocop:enable Metrics/ClassLength
