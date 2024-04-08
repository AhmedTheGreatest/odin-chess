# frozen_string_literal: true

require_relative 'chess'

# chess = Chess::Chess.new
chess = Chess::Chess.from_fen('rnb1kbn1/8/4r3/3B4/8/8/8/RN1QKBNR w KQq - 0 1')

chess.play
