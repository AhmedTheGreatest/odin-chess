# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/board'
require_relative '../../lib/pieces/bishop'

# rubocop:disable Metrics/BlockLength
describe Chess::Bishop do
  describe '#valid_moves' do
    context 'when the game is in the starting position' do
      board = Chess::Board.new
      bishop = board.board[0][2]
      it 'returns 0 moves' do
        expect(bishop.valid_moves(board, [0, 2]).length).to eq(0)
      end
    end

    context 'when there is no piece expect the bishop' do
      board = Chess::Board.from_fen('8/8/8/3b4/8/8/8/8 w - - 0 1')
      bishop = board.board[3][3]
      it 'returns many moves' do
        bishop_moves = bishop.valid_moves(board, [3, 3])
        correct_moves = [[4, 4], [5, 5], [6, 6], [7, 7], [4, 2], [5, 1], [6, 0], [2, 4], [1, 5], [0, 6], [2, 2],
                         [1, 1], [0, 0]]
        expect(bishop_moves).to match_array correct_moves
      end
    end

    context 'when the pawn in e7 pawn has moved' do
      board = Chess::Board.from_fen('rnbqkbnr/pppp1ppp/4p3/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      bishop = board.board[0][5]
      it 'returns correct moves' do
        bishop_moves = bishop.valid_moves(board, [0, 5])
        correct_moves = [[1, 4], [2, 3], [3, 2], [4, 1], [5, 0]]
        expect(bishop_moves).to match_array correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
