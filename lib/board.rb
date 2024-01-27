# frozen_string_literal: true

require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/queen'

module Chess
  # This class represents a Chess Board
  class Board
    attr_reader :board

    def initialize
      @board = Array.new(8) { Array.new(8) } # Ranks - Files
      setup_board
    end

    def setup_board
      add_first_row(0, :black)
      add_first_row(7, :white)
      add_pawns
    end

    def display
      current_color = :white
      board.each do |rank|
        rank.each do |cell|
          print_cell(cell, current_color)
          current_color = switch_color(current_color)
        end
        current_color = switch_color(current_color)
        puts ''
      end
    end

    def valid_position?(position)
      position.all? { |coord| coord.between?(0, 7) }
    end

    private

    def add_pawns
      8.times do |pawn|
        add_piece(1, pawn, :pawn, :black)
      end

      8.times do |pawn|
        add_piece(6, pawn, :pawn, :white)
      end
    end

    def add_first_row(rank, color)
      add_piece(rank, 0, :rook, color)
      add_piece(rank, 7, :rook, color)
      add_piece(rank, 6, :knight, color)
      add_piece(rank, 1, :knight, color)
      add_piece(rank, 2, :bishop, color)
      add_piece(rank, 5, :bishop, color)
      if rank.zero?
        add_piece(rank, 3, :queen, color)
        add_piece(rank, 4, :king, color)
      else
        add_piece(rank, 4, :queen, color)
        add_piece(rank, 3, :king, color)
      end
    end

    def print_cell(cell, current_color)
      if cell.is_a?(Piece)
        print cell.symbol.colorize(background: :light_white) if current_color == :white
        print cell.symbol.colorize(background: :light_black) if current_color == :black
      else
        print current_color == :white ? '  '.colorize(background: :light_white) : '  '.colorize(background: :light_black)
      end
    end

    def switch_color(current_color)
      return :black if current_color == :white

      :white if current_color == :black
    end

    def add_piece(rank, file, type, color)
      case type
      when :rook then board[rank][file] = Rook.new(color)
      when :bishop then board[rank][file] = Bishop.new(color)
      when :knight then board[rank][file] = Knight.new(color)
      when :pawn then board[rank][file] = Pawn.new(color)
      when :queen then board[rank][file] = Queen.new(color)
      when :king then board[rank][file] = King.new(color)
      end
    end
  end
end
