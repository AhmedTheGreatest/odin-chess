# frozen_string_literal: true

require_relative '../piece'

module Chess
  # A class representing a Pawn in a chess game
  class Pawn < Piece
    attr_reader :symbol

    def initialize(color)
      super(color)
      @symbol = color == :white ? "\u{2659} ".white : "\u{265F} ".black
    end

    def valid_moves(board, current_position, last_move_piece, last_move_position)
      moves = []

      forward_direction = color == :white ? -1 : 1

      # Regular move - 1 Square Forward
      moves << one_square_forward(current_position, forward_direction)

      # Initial move - 2 Square Forward
      moves << two_square_forward(current_position, forward_direction) if initial_row?(current_position)

      # Diagonal captures
      diagonal_capture_moves = diagonal_captures(board, current_position, forward_direction)
      moves.concat(diagonal_capture_moves) unless diagonal_capture_moves.empty?

      # En Passant moves
      en_passant_moves = en_passant(board, current_position, forward_direction, last_move_piece, last_move_position)
      moves.concat(en_passant_moves) unless en_passant_moves.empty?

      filter_valid_moves(board, moves, current_position, last_move_piece, last_move_position, forward_direction)
    end

    private

    def filter_valid_moves(board, moves, current_position, last_move_piece, last_move_position, direction)
      moves.select do |move|
        target_piece = board.board[move[0]][move[1]]
        destination_diagonal = (move[0] - current_position[0]).abs == 1 && (move[1] - current_position[1]).abs == 1

        next false unless board.valid_position?(move)

        next true if en_passant_capture?(move, last_move_piece, last_move_position, direction)

        # Diagonal capture move
        next !target_piece.nil? && target_piece.color != @color if destination_diagonal

        target_piece.nil?
      end
    end

    def en_passant(board, position, direction, last_move_piece, last_move_position)
      moves = []
      right_capture = right_diagonal_capture(position, direction)
      left_capture = left_diagonal_capture(position, direction)

      if valid_en_passant_move?(board.board, position, direction, -1,
                                last_move_piece, last_move_position)
        moves << right_capture
      end

      if valid_en_passant_move?(board.board, position, direction, 1,
                                last_move_piece, last_move_position)
        moves << left_capture
      end

      moves
    end

    def en_passant_capture?(move, last_move_piece, last_move_position, direction)
      return false unless last_move_piece && last_move_position

      en_passant_square = [last_move_position[0] + direction, last_move_position[1]]

      move[0] == en_passant_square[0] &&
        move[1] == en_passant_square[1] &&
        last_move_piece.is_a?(Pawn) &&
        last_move_piece.color != @color
    end

    def valid_en_passant_move?(board, position, forward_direction, sideways_direction,
                               last_move_piece, last_move_position)
      return false unless last_move_position && last_move_position.length == 2 && last_move_piece

      diagonal_piece_nil?(board, position, forward_direction, sideways_direction) &&
        side_piece_exists?(board, position, sideways_direction) &&
        last_move_position[0] == position[0] &&
        last_move_position[1] == position[1] + sideways_direction &&
        last_move_piece.is_a?(Pawn) &&
        last_move_piece.color != @color
    end

    def diagonal_piece_nil?(board, position, forward_direction, sideways_direction)
      board[position[0] + forward_direction][position[1] + sideways_direction].nil?
    end

    def side_piece_exists?(board, position, sideways_direction)
      !board[position[0]][position[1] + sideways_direction].nil?
    end

    def one_square_forward(current_position, direction)
      [current_position[0] + direction, current_position[1]]
    end

    def two_square_forward(current_position, direction)
      [current_position[0] + direction * 2, current_position[1]]
    end

    def diagonal_captures(board, position, direction)
      moves = []

      right_diagonal = right_diagonal_capture(position, direction)
      left_diagonal = left_diagonal_capture(position, direction)

      if board.valid_position?(right_diagonal) && board.board[right_diagonal[0]][right_diagonal[1]]
        moves << right_diagonal
      end
      moves << left_diagonal if board.valid_position?(left_diagonal) && board.board[left_diagonal[0]][left_diagonal[1]]

      moves
    end

    def right_diagonal_capture(current_position, direction)
      [current_position[0] + direction, current_position[1] + direction]
    end

    def left_diagonal_capture(current_position, direction)
      [current_position[0] + direction, current_position[1] - direction]
    end

    def initial_row?(current_position)
      initial_row = color == :white ? 6 : 1
      current_position[0] == initial_row
    end
  end
end
