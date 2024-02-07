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
      moves.concat(one_square(board, current_position))

      # 1 Square to each diagonal
      moves.concat(one_square_diagonal(board, current_position))

      moves.select { |move| board.valid_position?(move.to) }
    end

    private

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
        Move.new(current_position, new_position, self)
      elsif dest_square.color != color
        CaptureMove.new(current_position, new_position, self, new_position)
      end
    end
  end
end
