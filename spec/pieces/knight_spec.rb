# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/board'
require_relative '../../lib/pieces/knight'

# rubocop:disable Metrics/BlockLength
describe Chess::Knight do
  describe '#valid_moves' do
    context 'when the game is in the starting position' do
      board = Chess::Board.new
      knight = board.board[0][1]
      it 'returns 0 moves' do
        knight_moves = knight.valid_moves(board, [0, 1])
        correct_moves = [[2, 2], [2, 0]]
        expect(knight_moves).to match_array correct_moves
      end
    end

    context 'when there is no piece expect the knight' do
      board = Chess::Board.from_fen('8/8/8/3n4/8/8/8/8 w - - 0 1')
      knight = board.board[3][3]
      it 'returns many moves' do
        knight_moves = knight.valid_moves(board, [3, 3])
        correct_moves = [[4, 5], [5, 4], [2, 1], [1, 2], [4, 1], [5, 2], [2, 5], [1, 4]]
        expect(knight_moves).to match_array correct_moves
      end
    end

    context 'when the knight is at the corner of the board' do
      board = Chess::Board.from_fen('N7/8/8/8/8/8/8/8 w - - 0 1')
      knight = board.board[0][0]
      it 'returns only 2 moves' do
        knight_moves = knight.valid_moves(board, [0, 0])
        correct_moves = [[1, 2], [2, 1]]
        expect(knight_moves).to match_array correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
