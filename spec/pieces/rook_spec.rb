# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/board'
require_relative '../../lib/pieces/rook'

# rubocop:disable Metrics/BlockLength
describe Chess::Rook do
  describe '#valid_moves' do
    context 'when the game is in the starting position' do
      board = Chess::Board.new
      rook = board.board[0][0]
      it 'returns 0 moves' do
        expect(rook.valid_moves(board, [0, 0]).length).to eq(0)
      end
    end

    context 'when there is only 1 rook' do
      board = Chess::Board.from_fen('R7/8/8/8/8/8/8/8 w - - 0 1')
      rook = board.board[0][0]
      it 'returns many moves' do
        rook_moves = rook.valid_moves(board, [0, 0])
        correct_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [0, 1], [0, 2], [0, 3], [0, 4],
                         [0, 5], [0, 6], [0, 7]]
        expect(rook_moves).to match_array correct_moves
      end
    end

    context 'when the rook has a the pawn in front of it moved 2 square' do
      board = Chess::Board.from_fen('rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR b KQkq a3 0 1')
      rook = board.board[7][0]
      it 'returns many moves' do
        rook_moves = rook.valid_moves(board, [7, 0])
        correct_moves = [[6, 0], [5, 0]]
        expect(rook_moves).to match_array correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
