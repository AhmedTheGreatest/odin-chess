# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a King in a chess game
  class King < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2654} ".white : "\u{265A} ".black
    end

    def valid_moves(board, current_position)
      moves = []

      # 1 Square to each side
      moves.concat(one_square(current_position))

      # 1 Square to each diagonal
      moves.concat(one_square_diagonal(current_position))

      moves.select { |move| board.valid_position?(move) && board.board[move[0]][move[1]].nil? }
    end

    private

    def one_square(current_position)
      [
        [current_position[0] + 1, current_position[1]],
        [current_position[0] - 1, current_position[1]],
        [current_position[0], current_position[1] + 1],
        [current_position[0], current_position[1] - 1]
      ]
    end

    def one_square_diagonal(current_position)
      [
        [current_position[0] + 1, current_position[1] + 1],
        [current_position[0] - 1, current_position[1] - 1],
        [current_position[0] - 1, current_position[1] + 1],
        [current_position[0] + 1, current_position[1] - 1]
      ]
    end
  end
end
