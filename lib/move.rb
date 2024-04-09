# frozen_string_literal: true

module Chess
  # This class is a class that stores the information about a move
  class Move
    attr_reader :from, :to, :piece, :turn, :board

    def initialize(from, to, piece, board)
      @from = from
      @to = to
      @piece = piece
      @turn = piece.color
      @board = board
    end
  end
end
