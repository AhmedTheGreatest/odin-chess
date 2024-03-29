# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require_relative 'board'
module Chess
  # This class represents the chess game
  class Chess
    def initialize
      @board = Board.new
      @current_turn = :white
      @history = []
    end

    def play
      turn until game_end?
      @board.display
    end

    def game_end?
      false # TODO: Add Checkmate logic, Stalemate logic, and draw logic
    end

    def switch_turn
      @current_turn = @current_turn == :white ? :black : :white
    end

    private

    def turn
      @board.display
      make_move
      switch_turn
    end

    def make_move
      source_position = fetch_square
      piece = @board.board[source_position.first][source_position.last]

      move = fetch_destination(source_position)

      @board.set(move.to, piece)
      @board.remove_piece(source_position)
      @board.remove_piece(move.captured_position) if move.is_a?(CaptureMove)
      update_history(move)
    end

    def update_history(move)
      @history << move
    end

    def fetch_destination(source_position)
      position = fetch_position('enter the destination of the piece you want to move:')
      valid_move = nil
      loop do
        source_piece = @board.board[source_position[0]][source_position[1]]
        valid_moves = fetch_valid_moves(source_piece, source_position)

        valid_move = valid_moves.find { |move| move.to == position }
        break if valid_move

        puts 'Invalid move. Please choose a valid destination.'
        position = fetch_position('enter the destination of the piece you want to move:')
      end

      valid_move
    end

    def fetch_valid_moves(piece, position)
      return piece.valid_moves(@board, position, @history.last) if piece.is_a?(Pawn)

      piece.valid_moves(@board, position)
    end

    def fetch_position(prompt)
      puts "#{@current_turn == :white ? 'White' : 'Black'} #{prompt}"
      input = fetch_valid_input
      find_cell(input)
    end

    def fetch_square
      position = fetch_position('enter the position of the piece you want to move: (e4)')

      loop do
        break if @board.board[position[0]][position[1]] && @board.board[position[0]][position[1]].color == @current_turn

        puts 'Invalid move. Please choose a valid piece.'
        position = fetch_position('enter the position of the piece you want to move: (e4)')
      end

      position
    end

    def fetch_valid_input
      input = nil
      loop do
        input = gets.chomp.downcase
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
