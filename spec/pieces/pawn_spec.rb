# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'

# rubocop:disable Metrics/BlockLength
describe Chess::Pawn do
  describe '#valid_moves' do
    context 'when the game is in the starting position' do
      board = Chess::Board.new
      pawn = board.board[6][0]
      it 'returns 2 moves' do
        pawn_moves = pawn.valid_moves(board, [6, 0], nil, nil)
        correct_moves = [[5, 0], [4, 0]]
        move_positions = pawn_moves.map(&:to)
        expect(move_positions).to match_array correct_moves
      end
    end

    context 'when there is no piece expect the pawn' do
      board = Chess::Board.from_fen('rnbqkbnr/1ppppppp/p7/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      pawn = board.board[2][0]
      it 'returns one move' do
        pawn_moves = pawn.valid_moves(board, [2, 0], pawn, [2, 0])
        correct_moves = [[3, 0]]
        move_positions = pawn_moves.map(&:to)
        expect(move_positions).to match_array correct_moves
      end
    end

    context 'when there is a pawn in the capturing diagonal' do
      board = Chess::Board.from_fen('rnbqkbnr/1ppppppp/p7/1P6/8/8/P1PPPPPP/RNBQKBNR w KQkq - 0 1')
      pawn = board.board[2][0]
      it 'returns capturing move' do
        pawn_moves = pawn.valid_moves(board, [2, 0], board.board[3][1], [3, 1])
        correct_moves = [[3, 0], [3, 1]]
        move_positions = pawn_moves.map(&:to)

        expect(move_positions).to match_array correct_moves
      end
    end

    context 'when the pawn can en passant' do
      board = Chess::Board.from_fen('rnbqkbnr/pp1ppppp/8/1Pp5/8/8/P1PPPPPP/RNBQKBNR w KQkq - 0 1')
      pawn = board.board[3][1]
      it 'returns en passant move' do
        pawn_moves = pawn.valid_moves(board, [3, 1], board.board[3][2], [3, 2])
        correct_moves = [[2, 1], [2, 2]]
        move_positions = pawn_moves.map(&:to)

        expect(move_positions).to match_array correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
