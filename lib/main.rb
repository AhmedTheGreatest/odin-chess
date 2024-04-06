# frozen_string_literal: true

require_relative 'chess'

# chess = Chess::Chess.new
chess = Chess::Chess.from_fen('r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 1')

chess.play
