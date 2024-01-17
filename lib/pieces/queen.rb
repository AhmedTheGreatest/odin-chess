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
      moves += diagonal_moves(board, current_position)

      # Straight Moves
      moves += straight_moves(board, current_position)

      moves.select { |move| board.valid_position?(move) && board.board[move[0]][move[1]].nil? }
    end

    private

    def diagonal_moves(board, current_position)
      [
        moves(board, current_position, 1, 1),
        moves(board, current_position, 1, -1),
        moves(board, current_position, -1, 1),
        moves(board, current_position, -1, -1)
      ]
    end

    def straight_moves(board, current_position)
      [
        moves(board, current_position, 1, 0),
        moves(board, current_position, 0, 1),
        moves(board, current_position, -1, 0),
        moves(board, current_position, 0, -1)
      ]
    end

    def moves(board, current_position, row_delta, col_delta)
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
