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
      let(:previous_move) { double('Move', from: nil, to: nil, piece: nil, turn: nil) }

      it 'returns 2 moves' do
        pawn_moves = pawn.valid_moves(board, [6, 0], previous_move)
        correct_moves = [[5, 0], [4, 0]]
        move_positions = pawn_moves.map(&:to)
        expect(move_positions).to match_array correct_moves
      end
    end

    context 'when the a7 pawn has moved 1 square' do
      board = Chess::Board.from_fen('rnbqkbnr/1ppppppp/p7/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      pawn = board.board[2][0]
      let(:previous_move) { double('Move', from: [1, 0], to: [2, 0], piece: pawn, turn: pawn.color) }

      it 'returns one move' do
        pawn_moves = pawn.valid_moves(board, [2, 0], previous_move)
        correct_moves = [[3, 0]]
        move_positions = pawn_moves.map(&:to)
        expect(move_positions).to match_array correct_moves
      end
    end

    context 'when there is a pawn in the capturing diagonal' do
      board = Chess::Board.from_fen('rnbqkbnr/1pppppp1/p6p/1P6/8/8/P1PPPPPP/RNBQKBNR w KQkq - 0 1')
      pawn = board.board[2][0]

      let(:previous_move) do
        double('Move', from: [4, 1], to: [3, 1], piece: board.board[3][1], turn: board.board[3][1].color)
      end

      it 'returns capturing move' do
        pawn_moves = pawn.valid_moves(board, [2, 0], previous_move)
        correct_moves = [[3, 0], [3, 1]]
        move_positions = pawn_moves.map(&:to)

        expect(move_positions).to match_array correct_moves
      end
    end

    context 'when the pawn can en passant' do
      board = Chess::Board.from_fen('rnbqkbnr/pp1ppppp/8/1Pp5/8/8/P1PPPPPP/RNBQKBNR w KQkq - 0 1')
      pawn = board.board[3][1]
      let(:previous_move) do
        double('Move', from: [1, 2], to: [3, 2], piece: board.board[3][2], turn: board.board[3][2].color)
      end

      it 'returns en passant move' do
        pawn_moves = pawn.valid_moves(board, [3, 1], previous_move)
        correct_moves = [[2, 1], [2, 2]]
        move_positions = pawn_moves.map(&:to)

        expect(move_positions).to match_array correct_moves
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
