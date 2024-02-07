# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/board'
require_relative '../../lib/pieces/king'

describe Chess::King do
  describe '#valid_moves' do
    context 'when the game is in the starting position' do
      board = Chess::Board.new
      king = board.board[0][4]
      it 'returns 0 moves' do
        expect(king.valid_moves(board, [0, 4]).length).to eq(0)
      end
    end

    context 'when there is no piece expect the king' do
      board = Chess::Board.from_fen('8/8/8/3K4/8/8/8/8 w - - 0 1')
      king = board.board[3][3]
      it 'returns all of his 8 moves' do
        king_moves = king.valid_moves(board, [3, 3])
        correct_moves = [[4, 3], [2, 3], [3, 4], [3, 2], [4, 4], [2, 2], [2, 4], [4, 2]]
        move_positions = king_moves.map(&:to)
        expect(move_positions).to match_array correct_moves
      end
    end
  end
end
