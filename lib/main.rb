# frozen_string_literal: true

require_relative 'chess'

chess = Chess::Chess.new
# chess = Chess::Chess.from_fen('rnbqkbnr/pppp1ppp/8/4p3/6P1/5P2/PPPPP2P/RNBQKBNR b KQkq - 0 1')

chess.play
