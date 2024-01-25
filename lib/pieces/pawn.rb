require_relative '../piece'

module Chess
  # A class representing a Pawn in a chess game
  class Pawn < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2659} ".white : "\u{265F} ".black
    end

    def valid_moves(board, current_position, _opposing_first_move)
      moves = []

      forward_direction = color == :white ? -1 : 1

      # Regular move - 1 Square Forward
      moves << one_square_forward(current_position, forward_direction)

      # Initial move - 2 Square Forward
      moves << two_square_forward(current_position, forward_direction) if intial_row?(current_position)

      # Diagonal captures
      diagonal_capture_moves = diagonal_captures(board.board, current_position, forward_direction)
      moves << diagonal_capture_moves if diagonal_capture_moves
      filter_valid_moves(board, moves, current_position)
    end

    private

    def filter_valid_moves(board, moves, current_position)
      moves.select do |move|
        target_piece = board.board[move[0]][move[1]]
        destination_diagonal = (move[0] - current_position[0]).abs == 1 && (move[1] - current_position[1]).abs == 1

        board.valid_position?(move) && target_piece.nil? && !destination_diagonal
      end
    end

    def one_square_forward(current_position, direction)
      [current_position[0] + direction, current_position[1]]
    end

    def two_square_forward(current_position, direction)
      [current_position[0] + direction * 2, current_position[1]]
    end

    def diagonal_captures(board, position, direction)
      moves = []
      moves << right_diagonal_capture(position, direction) if board[position[0] + direction][position[1] + 1]
      moves << left_diagonal_capture(position, direction) if board[position[0] + direction][position[1] - 1]
    end

    def right_diagonal_capture(current_position, direction)
      [current_position[0] + direction, current_position[1] + direction]
    end

    def left_diagonal_capture(current_position, direction)
      [current_position[0] + direction, current_position[1] - direction]
    end

    def intial_row?(current_position)
      initial_row = color == :white ? 6 : 1
      current_position[0] == initial_row
    end
  end
end
