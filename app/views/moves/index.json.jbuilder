json.array!(@moves) do |move|
  json.extract! move, :id, :game_id, :player_id, :square, :symbol
  json.url move_url(move, format: :json)
end
