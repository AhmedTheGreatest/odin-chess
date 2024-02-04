# frozen_string_literal: true

module Chess
  # This class is a class that stores the information about a move
  class Move
    attr_reader :from, :to, :piece

    def initialize(from, to, piece)
      @from = from
      @to = to
      @piece = piece
    end
  end
end
