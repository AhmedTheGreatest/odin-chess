# frozen_string_literal: true

require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require 'colorize'

module Chess
  # This class represents a Chess Board
  class Board
    attr_reader :board

    def initialize
      @board = Array.new(8) { Array.new(8) } # Ranks - Files
      setup_board
    end

    def self.from_fen(fen)
      board = Board.new
      board.load_fen(fen)
      board
    end

    def setup_board
      load_fen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    end

    def display
      current_color = :white
      board.each_with_index do |rank, index|
        print "#{(index - 8).abs} ".blue.bold
        print_rank(rank, current_color)
        current_color = switch_color(current_color)
        puts ''
      end
      puts '  a b c d e f g h'.blue.bold
    end

    def valid_position?(position)
      position.all? { |coord| coord.between?(0, 7) }
    end

    def set(position, value)
      @board[position[0]][position[1]] = value
    end

    def get(position)
      @board[position[0]][position[1]]
    end

    def remove_piece(position)
      @board[position[0]][position[1]] = nil
    end

    def load_fen(fen)
      fen_parts = fen.split(' ')
      rows = fen_parts[0].split('/')

      rows.each_with_index do |row, i|
        col_index = 0
        row.each_char do |char|
          if char.match?('\d')
            fill_empty_squares(i, col_index)
            col_index += char.to_i
          else
            process_non_empty_square(char, i, col_index)
            col_index += 1
          end
        end
        fill_empty_squares(i, col_index) if col_index.positive?
      end
    end

    private

    def print_rank(rank, color)
      rank.each do |cell|
        print_cell(cell, color)
        color = switch_color(color)
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

    def process_non_empty_square(piece, row, col)
      piece_map = {
        'r' => Rook.new(:black), 'n' => Knight.new(:black), 'b' => Bishop.new(:black), 'q' => Queen.new(:black),
        'k' => King.new(:black), 'p' => Pawn.new(:black),
        'R' => Rook.new(:white), 'N' => Knight.new(:white), 'B' => Bishop.new(:white), 'Q' => Queen.new(:white),
        'K' => King.new(:white), 'P' => Pawn.new(:white)
      }
      @board[row][col] = piece_map[piece]
    end

    def fill_empty_squares(row_index, col_index)
      (col_index...@board[row_index].size).each { |col| @board[row_index][col] = nil }
    end
  end
end
