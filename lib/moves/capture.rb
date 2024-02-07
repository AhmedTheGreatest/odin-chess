# frozen_string_literal: true

require_relative '../move'

module Chess
  # This class represents a capture in a Chess game
  class CaptureMove < Move
    attr_reader :captured_position

    def initialize(from, to, piece, captured_position)
      super(from, to, piece)
      @captured_position = captured_position
    end
  end
end
