# frozen_string_literal: true

require_relative '../move'

module Chess
  # EnPassant is a special type of capture in a Chess game for pawns
  class EnPassantMove < CaptureMove; end
end
