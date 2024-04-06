# frozen_string_literal: true

require 'colorize'
require_relative 'move'
require_relative 'moves/capture'
require_relative 'moves/en_passant'
require_relative 'moves/castle'

module Chess
  # The base class for a chess piece
  class Piece
    attr_reader :color

    def initialize(color)
      @color = color
    end
  end
end
