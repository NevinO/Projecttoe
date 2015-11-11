class Game < ActiveRecord::Base
  has_many :moves
  has_and_belongs_to_many :users

  WINNING_LINES = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6] ]

  def make_move(player, square)
          Move.create(square: square, symbol: symbol_for_player(player), player: player, game: self)
          save!
    end

    def finished?
      winning_game? || drawn_game?
    end

    def result
      case
      when winning_game?
        "#{moves.last.player} is the best in the world!"
      when drawn_game?
        "Tie Game!"
      else
        "This one's a real slobber-knocker."
      end
    end

    def whose_turn
      return player1_id if moves.empty?
      moves.last.player == player1_id ? player2_id : player1_id
    end

    def board
      empty_board.tap do |board|
        moves.each do |move|
          board[move.square] = move.symbol
        end
      end
    end

    def empty_board
      Array.new(9,nil)
    end

    # def acceptable_move?(square)
    #   square < 9 && square > -1 
    # end

    private
    def winning_game?
      !!WINNING_LINES.detect do |winning_line|
        %w(XXX OOO).include?(winning_line.map { |e| board[e] }.join)
      end
    end

    private
    def drawn_game?
      moves.size == 9
    end

    private
    def symbol_for_player(player)
      case player
      when player1_id
        'X'
      when player2_id
        'O'
      else
        raise "Failed to assign symbols"
      end
    end
end
