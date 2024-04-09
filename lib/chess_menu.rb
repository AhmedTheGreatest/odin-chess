# frozen_string_literal: true

require_relative 'chess'

module Chess
  # This class represents the chess game
  class ChessMenu
    def display_menu
      menu
    end

    private

    def menu
      display_menu_messages
      menu_input
    end

    def display_menu_messages
      puts 'Welcome to Chess! Please choose one of the following options:'.bold.red
      puts "#{'[1]'.cyan.bold} #{'Start New Game'.bold.cyan}"
      puts "#{'[2]'.cyan.bold} #{'Load an existing game'.bold.cyan}"
    end

    def menu_input
      input = fetch_menu_input
      if input == 1
        game = Chess.new
        game.play
      elsif input == 2
        load
      end
    end

    def load
      games = Dir.entries('games')[0..-3]
      display_load_options(games)
      file_path = file_to_load(games)
      game = Chess.load_game(file_path)
      game.play
    end

    def display_load_options(games)
      puts 'Which game do you want to open?'.bold.red
      games.each_with_index do |game, index|
        puts "#{"[#{index + 1}]".bold.cyan} #{game.bold.cyan}"
      end
    end

    # Asks the user for the file and returns its path
    def file_to_load(games)
      option = gets.chomp.to_i - 1
      "games/#{games[option]}"
    end

    def fetch_menu_input
      input = nil
      loop do
        input = gets.chomp.to_i
        break if (0..2).cover?(input)
      end
      input
    end
  end
end
