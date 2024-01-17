require_relative '../piece'

module Chess
  # A class representing a Pawn in a chess game
  class Pawn < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2659} ".white : "\u{265F} ".black
    end

    def valid_moves(board, current_position)
      moves = []

      forward_direction = color == :white ? -1 : 1

      # Regular move - 1 Square Forward
      moves << one_square_forward(current_position, forward_direction)

      # Initial move - 2 Square Forward
      moves << two_square_forward(current_position, forward_direction) if intial_row?(current_position)

      # Diagonal captures
      moves += diagonal_captures(current_position, forward_direction)

      moves.select { |move| board.valid_position?(move) && board.board[move[0]][move[1]].nil? }
    end

    private

    def one_square_forward(current_position, direction)
      [current_position[0] + direction, current_position[1]]
    end

    def two_square_forward(current_position, direction)
      [current_position[0] + direction * 2, current_position[1]]
    end

    def diagonal_captures(current_position, direction)
      [
        [current_position[0] + direction, current_position[1] + direction],
        [current_position[0] + direction, current_position[1] - direction]
      ]
    end

    def intial_row?(current_position)
      initial_row = color == :white ? 6 : 1
      current_position[0] == initial_row
    end
  end
end
