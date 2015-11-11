class Move < ActiveRecord::Base
  belongs_to :game

  validates :value, inclusion: { in: %w(o x) }

    validate :on_board, on: :create
    validate :empty_square, on: :create
    validate :own_turn, on: :create

    def on_board
      errors.add(:square, "Does not compute") unless (0..8).include? self.square
    end

    def vacant_square
      errors.add(:square, "Occupied, yo!") if Move.where(game_id: self.game_id).pluck(:square).include? self.square
    end

    def own_turn
      errors.add(:player_id, "I don't remember asking you a damn thing") unless self.player_id == Game.find(self.game_id).whose_turn
    end
end
