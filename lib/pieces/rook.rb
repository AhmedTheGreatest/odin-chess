# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a Rook in a chess game
  class Rook < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2656} ".white : "\u{265C} ".black
    end

    def valid_moves(board, current_position)
      moves = []
      # Straight Moves in all sides
      moves += straight_moves(board, current_position, 1, 0)
      moves += straight_moves(board, current_position, 0, 1)

      moves += straight_moves(board, current_position, -1, 0)
      moves += straight_moves(board, current_position, 0, -1)

      filter_valid_moves(board, moves)
    end

    private

    def filter_valid_moves(board, moves)
      moves.select { |move| board.valid_position?(move.to) }
    end

    def straight_moves(board, current_position, row_delta, col_delta)
      moves = []

      row, col = current_position

      while board.valid_position?([row + row_delta, col + col_delta])
        next_row = row + row_delta
        next_col = col + col_delta
        next_square = board.board[next_row][next_col]

        if next_square.nil?
          moves << Move.new(current_position, [next_row, next_col], self)
        else
          move = CaptureMove.new(current_position, [next_row, next_col], self, [next_row, next_col])
          moves << move if next_square.color != color
          break
        end

        row += row_delta
        col += col_delta
      end

      moves
    end
  end
end
