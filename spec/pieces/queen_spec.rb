# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/board'
require_relative '../../lib/pieces/queen'

# rubocop:disable Metrics/BlockLength
describe Chess::Queen do
  describe '#valid_moves' do
    context 'when the game is in the starting position' do
      board = Chess::Board.new
      queen = board.board[0][3]
      it 'returns 0 moves' do
        expect(queen.valid_moves(board, [0, 3]).length).to eq(0)
      end
    end

    context 'when there is no piece expect the queen' do
      board = Chess::Board.from_fen('3q4/8/8/8/8/8/8/8 w - - 0 1')
      queen = board.board[0][3]
      it 'returns many moves' do
        queen_moves = queen.valid_moves(board, [0, 3])
        correct_moves = [[1, 4], [2, 5], [3, 6], [4, 7], [1, 2], [2, 1], [3, 0], [1, 3], [2, 3], [3, 3], [4, 3],
                         [5, 3], [6, 3], [7, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 2], [0, 1], [0, 0]]
        expect(queen_moves).to eql correct_moves
      end
    end

    context 'when the queen has a the pawn in front of it moved 2 square' do
      board = Chess::Board.from_fen('rnbqkbnr/ppp1pppp/8/3p4/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      queen = board.board[0][3]
      it 'returns correct moves' do
        queen_moves = queen.valid_moves(board, [0, 3])
        correct_moves = [[1, 3], [2, 3]]
        expect(queen_moves).to eql correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
