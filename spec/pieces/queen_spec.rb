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
      board.display
      queen = board.board[0][3]
      p board.board[0][2]
      p board.board
      it 'returns many moves' do
        queen_moves = queen.valid_moves(board, [0, 3])
        # correct_moves = []
        p queen_moves
        # expect(queen_moves).to eql correct_moves
      end
    end

    context 'when the queen has a the pawn in front of it moved 2 square' do
      board = Chess::Board.from_fen('rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR b KQkq a3 0 1')
      queen = board.board[7][0]
      it 'returns many moves' do
        queen_moves = queen.valid_moves(board, [7, 0])
        correct_moves = [[6, 0], [5, 0]]
        expect(queen_moves).to eql correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
