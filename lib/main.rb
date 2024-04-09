# frozen_string_literal: true

require_relative 'chess_menu'

chess = Chess::ChessMenu.new
# chess = Chess::Chess.from_fen('4k3/8/8/8/7b/8/6N1/4K3 w - - 0 1')

# chess.play
chess.display_menu
