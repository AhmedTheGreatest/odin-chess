# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a Queen in a chess game
  class Queen < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2655} ".white : "\u{265B} ".black
    end

    def valid_moves(board, current_position)
      moves = []

      # Diagonal Moves
      diagonal = diagonal_moves(board, current_position)
      moves.concat(diagonal) unless diagonal.empty?

      # Straight Moves
      straight = straight_moves(board, current_position)
      moves.concat(straight) unless straight.empty?

      filter_valid_moves(board, moves)
    end

    private

    def filter_valid_moves(board, moves)
      moves.select { |move| board.valid_position?(move.to) && board.board[move.to[0]][move.to[1]].nil? }
    end

    def diagonal_moves(board, current_position)
      [
        moves(board, current_position, 1, 1),
        moves(board, current_position, 1, -1),
        moves(board, current_position, -1, 1),
        moves(board, current_position, -1, -1)
      ].reject(&:empty?).flatten(1)
    end

    def straight_moves(board, current_position)
      [
        moves(board, current_position, 1, 0),
        moves(board, current_position, 0, 1),
        moves(board, current_position, -1, 0),
        moves(board, current_position, 0, -1)
      ].reject(&:empty?).flatten(1)
    end

    def moves(board, current_position, row_delta, col_delta)
      moves = []

      row, col = current_position

      while board.valid_position?([row + row_delta, col + col_delta])
        move = Move.new(current_position, [row + row_delta, col + col_delta], self)
        moves << move
        break unless board.board[row + row_delta][col + col_delta].nil?

        row += row_delta
        col += col_delta
      end

      moves
    end
  end
end
