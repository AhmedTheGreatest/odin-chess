# frozen_string_literal: true

require 'rspec'
require_relative '../lib/chess'

describe Chess::Chess do
  describe '#game_end?' do
    it 'returns false if the game is not over' do
      game = described_class.new
      expect(game.game_end?).to eq(false)
    end

    xit 'returns true if the game is over' do
      game = described_class.new
      expect(game.game_end?).to eq(true) # TODO: implement the game_end? method
    end
  end

  describe '#switch_turn' do
    it 'switches current turn from :white to :black' do
      game = described_class.new
      expect { game.switch_turn }.to change { game.instance_variable_get(:@current_turn) }.from(:white).to(:black)
    end

    it 'switches current turn from :black to :white' do
      game = described_class.new
      game.instance_variable_set(:@current_turn, :black)
      expect { game.switch_turn }.to change { game.instance_variable_get(:@current_turn) }.from(:black).to(:white)
    end
  end
end
