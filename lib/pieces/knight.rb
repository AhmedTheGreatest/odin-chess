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
      moves += knight_moves(current_position)

      moves.select { |move| board.valid_position?(move) && board.board[move[0]][move[1]].nil? }
    end

    private

    def knight_moves(current_position)
      [
        [knight_move(current_position, 1, 2)],
        [knight_move(current_position, 2, 1)],
        [knight_move(current_position, -1, -2)],
        [knight_move(current_position, -2, -1)],
        [knight_move(current_position, 1, -2)],
        [knight_move(current_position, 2, -1)],
        [knight_move(current_position, -1, 2)],
        [knight_move(current_position, -2, 1)]
      ]
    end

    def knight_move(current_position, row_delta, col_delta)
      row, col = current_position

      new_row = row + row_delta
      new_col = col + col_delta

      [[new_row, new_col], [new_row + row_delta, new_col + col_delta]]
    end
  end
end
