# frozen_string_literal: true

require_relative 'chess'

# chess = Chess::Chess.new

# chess.play

board = Chess::Board.from_fen('pnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
board.display
