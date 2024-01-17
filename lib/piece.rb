# frozen_string_literal: true

require 'colorize'

module Chess
  # The base class for a chess piece
  class Piece
    attr_reader :color

    def initialize(color)
      @color = color
    end
  end
end
