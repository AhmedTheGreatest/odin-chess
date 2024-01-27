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
      # Straigth Moves in all sides
      moves += straight_moves(board, current_position, 1, 0)
      moves += straight_moves(board, current_position, 0, 1)

      moves += straight_moves(board, current_position, -1, 0)
      moves += straight_moves(board, current_position, 0, -1)

      moves.select { |move| board.valid_position?(move) && board.board[move[0]][move[1]].nil? }
    end

    private

    def straight_moves(board, current_position, row_delta, col_delta)
      moves = []

      row, col = current_position

      while board.valid_position?([row + row_delta, col + col_delta])
        moves << [row + row_delta, col + col_delta]
        break unless board.board[row + row_delta][col + col_delta].nil?

        row += row_delta
        col += col_delta
      end

      moves
    end
  end
end
