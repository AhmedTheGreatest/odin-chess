# frozen_string_literal: true

require 'rspec'
require_relative '../lib/board'

# rubocop:disable Metrics/BlockLength
describe Chess::Board do
  describe '#valid_position?' do
    it 'returns true for position within bounds' do
      board = Chess::Board.new
      position = [3, 4]
      expect(board.valid_position?(position)).to eq(true)
    end

    it 'returns false for position outside bounds' do
      board = Chess::Board.new
      position = [8, 8]
      expect(board.valid_position?(position)).to eq(false)
    end
  end

  describe '#setup_board' do
    it 'sets up the board with pieces in valid starting positions' do
      board = Chess::Board.new
      # Check sample positions to verify setup
      expect(board.board[0][0]).to be_a(Chess::Rook)
      expect(board.board[1][0]).to be_a(Chess::Pawn)
    end
  end

  describe '#display' do
    it 'prints the board visualization to stdout' do
      board = Chess::Board.new
      expect { board.display }.to output.to_stdout
    end
  end

  describe '#set' do
    it 'set the upper left cell to the correct a Rook' do
      board = Chess::Board.new
      rook = Chess::Rook.new(:white)
      expect { board.set([0, 0], rook.symbol) }.to change { board.board[0][0] }.to(rook.symbol)
    end
  end
end

# rubocop:enable Metrics/BlockLength
