# frozen_string_literal: true

module Chess
  # This class determines if the king is in check or not.
  class CheckDetermination
    def self.for?(color, board)
      king_position = fetch_king_position(color, board)

      valid_moves = moves_of_pieces(color, board)
      move_destinations = fetch_destination_of_moves(valid_moves)

      return true if move_destinations.include?(king_position)

      false
    end

    def self.position_for?(color, position, board)
      valid_moves = moves_of_pieces(color, board)
      move_destinations = fetch_destination_of_moves(valid_moves)

      return true if move_destinations.include?(position)

      false
    end

    def self.fetch_king_position(color, board)
      board.board.each_with_index do |rank, rank_index|
        rank.each_with_index do |piece, file_index|
          return [rank_index, file_index] if piece&.color == color && piece.is_a?(King)
        end
      end
    end

    def self.moves_of_pieces(color, board)
      moves = []

      board.board.each_with_index do |rank, rank_index|
        rank.each_with_index do |piece, file_index|
          next if piece.nil? || piece.color == color

          valid_moves = fetch_valid_moves(piece, [rank_index, file_index], board)
          moves.concat(valid_moves)
        end
      end

      moves
    end

    def self.fetch_destination_of_moves(moves)
      moves.map(&:to)
    end

    def self.fetch_valid_moves(piece, position, board)
      return piece.valid_moves(board, position, nil) if piece.is_a?(Pawn)

      piece.valid_moves(board, position)
    end
  end
end
