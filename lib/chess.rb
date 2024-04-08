# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require_relative 'board'
require_relative 'check_determination'
module Chess
  # This class represents the chess game
  class Chess
    attr_reader :current_turn, :history, :full_move_clock, :half_move_clock, :white_king_pos, :black_king_pos

    BACK_COMMAND = 'back'

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

    def play
      log_messages
      turn until game_end?
      @board.display
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
      false # TODO: Add Checkmate logic, Stalemate logic, and draw logic
    end

    def switch_turn
      @current_turn = @current_turn == :white ? :black : :white
    end

    # def in_check?(position)
    #   king_piece =  @board.get(position)
    #   valid_moves = moves_of_pieces(king_piece.color == :white ? :black : :white)
    #   move_destinations = fetch_destination_of_moves(valid_moves)

    #   return true if move_destinations.include?(position)

    #   false
    # end

    private

    def update_check_state
      @white_check = CheckDetermination.for?(:white, @board)
      @black_check = CheckDetermination.for?(:black, @board)
    end

    # def moves_of_pieces(color)
    #   moves = []

    #   @board.board.each_with_index do |rank, rank_index|
    #     rank.each_with_index do |piece, file_index|
    #       next if piece.nil? || piece.color != color

    #       valid_moves = fetch_valid_moves(piece, [rank_index, file_index])
    #       moves.concat(valid_moves)
    #     end
    #   end

    #   moves
    # end

    # def fetch_destination_of_moves(moves)
    #   moves.map(&:to)
    # end

    # def fetch_king_position(color)
    #   @board.board.each_with_index do |rank, rank_index|
    #     rank.each_with_index do |piece, file_index|
    #       return [rank_index, file_index] if piece&.color == color && piece.is_a?(King)
    #     end
    #   end
    # end

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
      @board.display
      make_move
      log_messages
      switch_turn
    end

    def log_messages
      puts "Full moves: #{@full_move_clock}"
      puts "Half moves: #{@half_move_clock}"
      # puts "White King Position: #{@white_king_pos}"
      # puts "Black King Position: #{@black_king_pos}"
      puts 'White is in CHECK!' if CheckDetermination.for?(:white, @board)
      puts 'Black is in CHECK!' if CheckDetermination.for?(:black, @board)
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

      piece.valid_moves(@board, position)
    end

    def fetch_position(prompt)
      puts "#{@current_turn == :white ? 'White' : 'Black'} #{prompt}"
      input = fetch_valid_input
      return input if input == BACK_COMMAND

      find_cell(input)
    end

    def fetch_square
      loop do
        position = fetch_position('enter the position of the piece you want to move: (e4)')

        next if position == BACK_COMMAND

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
        break if input == BACK_COMMAND
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
