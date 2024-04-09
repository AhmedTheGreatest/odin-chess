# frozen_string_literal: true

require_relative 'chess_menu'

chess = Chess::ChessMenu.new
chess = Chess::Chess.from_fen('8/2k1r3/8/8/8/8/2K1R3/8 w - - 0 1')

# chess.display_menu
chess.play
