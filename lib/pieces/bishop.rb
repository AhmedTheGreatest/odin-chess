# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a Bishop in a chess game
  class Bishop < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2657} ".white : "\u{265D} ".black
    end

    def valid_moves(board, current_position)
      moves = []

      # Diagonal Moves
      moves += diagonal_moves(board, current_position, 1, 1)
      moves += diagonal_moves(board, current_position, 1, -1)
      moves += diagonal_moves(board, current_position, -1, 1)
      moves += diagonal_moves(board, current_position, -1, -1)

      moves.select { |move| board.valid_position?(move.to) }
    end

    private

    def diagonal_moves(board, current_position, row_delta, col_delta)
      moves = []

      row, col = current_position

      while board.valid_position?([row + row_delta, col + col_delta])
        next_row = row + row_delta
        next_col = col + col_delta
        next_square = board.board[next_row][next_col]

        if next_square.nil?
          moves << Move.new(current_position, [row + row_delta, col + col_delta], self, board.board)
        else
          if next_square.color != color
            moves << CaptureMove.new(current_position, [next_row, next_col], self, [next_row, next_col], board.board)
          end
          break
        end

        row += row_delta
        col += col_delta
      end

      moves
    end
  end
end
