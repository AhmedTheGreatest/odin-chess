# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a King in a chess game
  class King < Piece
    attr_reader :symbol
    attr_accessor :has_moved

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2654} ".white : "\u{265A} ".black
      @has_moved = false
    end

    def valid_moves(board, current_position, check: false)
      moves = []

      # 1 Square to each side
      moves.concat(one_square(board, current_position))

      # 1 Square to each diagonal
      moves.concat(one_square_diagonal(board, current_position))

      # Castling
      castle_moves = castle_moves(board, current_position, check: check).reject(&:nil?)
      moves.concat(castle_moves) unless castle_moves.empty?

      moves.select { |move| board.valid_position?(move.to) }
    end

    private

    def castle_moves(board, current_position, check: false)
      return [] if check

      [
        king_side_castle(board, current_position),
        queen_side_castle(board, current_position)
      ]
    end

    def king_side_castle(board, current_position)
      # TODO: Castling
      rook_position = fetch_rook_for_castle(:king)
      return nil unless empty_squares_in_between_rank?(board, current_position, rook_position)

      rook_piece = board.get(rook_position)
      return nil unless rook_piece.is_a?(Rook) && rook_piece.color == @color

      return nil if rook_piece.has_moved || @has_moved

      new_position = [current_position[0], current_position[1] + 2]
      new_rook_position = [current_position[0], current_position[1] + 1]

      CastleMove.new(current_position, new_position, self, rook_position, new_rook_position, rook_piece)
    end

    def queen_side_castle(board, current_position)
      rook_position = fetch_rook_for_castle(:queen)

      return nil unless empty_squares_in_between_rank?(board, current_position, rook_position)

      rook_piece = board.get(rook_position)
      return nil unless rook_piece.is_a?(Rook) && rook_piece.color == @color

      return nil if rook_piece.has_moved || @has_moved

      new_position = [current_position[0], current_position[1] - 2]
      new_rook_position = [current_position[0], current_position[1] - 1]

      CastleMove.new(current_position, new_position, self, rook_position, new_rook_position, rook_piece)
    end

    def fetch_rook_for_castle(side)
      rook_file = side == :king ? 7 : 0
      rook_rank = @color == :white ? 7 : 0

      [rook_rank, rook_file]
    end

    def empty_squares_in_between_rank?(board, position_a, position_b)
      rank, file = position_a
      diff = calculate_difference(file, position_b[1])
      # Check each square until reaching position_b
      loop do
        # Check if the next square is a valid position
        break unless board.valid_position?([rank, file + diff])

        break if CheckDetermination.position_for?(@color, [rank, file], board)

        next_file = file + diff
        next_square = board.board[rank][next_file]

        return true if position_b == [rank, next_file] && next_square.is_a?(Rook)

        # If the next square is occupied, return false
        return false unless next_square.nil?

        file += diff
      end

      false
    end

    def calculate_difference(num_a, num_b)
      diff = num_b - num_a
      diff /= diff.abs # Normalize the difference to either -1 or 1
      diff
    end

    def one_square(board, current_position)
      [
        new_move(board, current_position, [current_position[0] + 1, current_position[1]]),
        new_move(board, current_position, [current_position[0] - 1, current_position[1]]),
        new_move(board, current_position, [current_position[0], current_position[1] + 1]),
        new_move(board, current_position, [current_position[0], current_position[1] - 1])
      ].reject(&:nil?)
    end

    def one_square_diagonal(board, current_position)
      [
        new_move(board, current_position, [current_position[0] + 1, current_position[1] + 1]),
        new_move(board, current_position, [current_position[0] - 1, current_position[1] - 1]),
        new_move(board, current_position, [current_position[0] - 1, current_position[1] + 1]),
        new_move(board, current_position, [current_position[0] + 1, current_position[1] - 1])
      ].reject(&:nil?)
    end

    def new_move(board, current_position, new_position)
      dest_square = board.board[new_position[0]][new_position[1]] if board.valid_position?(new_position)

      if dest_square.nil?
        Move.new(current_position, new_position, self, board.board)
      elsif dest_square.color != color
        CaptureMove.new(current_position, new_position, self, new_position, board.board)
      end
    end
  end
end
