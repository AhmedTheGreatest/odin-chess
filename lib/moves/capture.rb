# frozen_string_literal: true

require_relative '../move'

# This class represents a capture in a Chess game
class CaptureMove < Move
  def initialize(from, to, piece, captured)
    super(from, to, piece)
    @captured = captured
  end
end
