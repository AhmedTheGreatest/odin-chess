# frozen_string_literal: true

require_relative '../move'

module Chess
  # This class represents a capture in a Chess game
  class CastleMove < Move
    attr_reader :previous_rook_position, :new_rook_position, :rook_piece

    def initialize(from, to, piece, rook_position, new_rook_position, rook_piece, board)
      super(from, to, piece, board)
      @previous_rook_position = rook_position
      @new_rook_position = new_rook_position
      @rook_piece = rook_piece
      # @side = side # Sides are :king and :queen
    end
  end
end
