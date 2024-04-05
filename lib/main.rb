# frozen_string_literal: true

require_relative 'chess'

# chess = Chess::Chess.new
chess = Chess::Chess.from_fen('rnbqkbnr/ppp1pppp/8/8/P3Pp2/8/1PPP1PPP/RNBQKBNR b KQkq e3 0 1')

chess.play
