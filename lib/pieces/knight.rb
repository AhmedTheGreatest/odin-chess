# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a Bishop in a chess game
  class Knight < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2658} ".white : "\u{265E} ".black
    end

    def valid_moves(board, current_position)
      moves = []

      # Knight L Shaped Moves
      moves += knight_moves(board, current_position)

      moves.select { |move| board.valid_position?(move.to) }
    end

    private

    def knight_moves(board, current_position)
      [
        knight_move(board, current_position, 1, 2),
        knight_move(board, current_position, 2, 1),
        knight_move(board, current_position, -1, -2),
        knight_move(board, current_position, -2, -1),
        knight_move(board, current_position, 1, -2),
        knight_move(board, current_position, 2, -1),
        knight_move(board, current_position, -1, 2),
        knight_move(board, current_position, -2, 1)
      ].reject(&:nil?)
    end

    def knight_move(board, current_position, row_delta, col_delta)
      row, col = current_position

      next_row = row + row_delta
      next_col = col + col_delta
      next_square = board.board[next_row]&.[](next_col)

      if next_square.nil?
        Move.new(current_position, [next_row, next_col], self)
      elsif next_square.color != color
        CaptureMove.new(current_position, [next_row, next_col], self, [next_row, next_col])
      end
    end
  end
end
