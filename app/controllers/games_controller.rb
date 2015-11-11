class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]


  def index
    @games = Game.all
  end

  
  def show
  end

  
  def new
    @game = Game.new
  end

  
  def edit
  end

  
  def create
    @game = Game.new(game_params)

    game.player1_id = current_user.id
        game.users << player_1 = User.find(game.player1_id)
        game.users << player_2 = User.find(game.player2_id)
        symbols = ['x','o']
        game.save
        redirect_to game
  end


  def update
    @game = Game.find(params[:id])
        @current_player = User.find(@game.whose_turn)
        @player_1 = User.find(@game.player1_id)
        @player_2 = User.find(@game.player2_id)

    move = Move.create(player_id: @current_player.id ,game_id: params[:id],square: params[:square], value: @symbol)

        @game.moves << move
        @game.update_board

        if @game.moves.size >= 5
          if @game.winning_game?
            @game.winner_id = @game.moves.last.player_id
          else
            @game.is_draw = 'true' if @game.drawn_game? 
          end
        end

        @game.save
        if @game.ai_playing? && !@game.finished?
          @game.load_ai if @game.ai_turn?

          @game.update_board

          if @game.moves.size >= 5
            if @game.winning_game?
              @game.winner_id = @game.moves.last.player_id
            else
              @game.is_draw = 'true' if @game.drawn_game? 
            end
          end

          @game.save
        end

        redirect_to @game
  end


  private
    
    def game_params
      params.require(:game).permit(:player1_id, :player2_id, :board, :winner_id)
    end
end
