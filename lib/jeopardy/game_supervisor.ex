defmodule Jeopardy.GameSupervisor do
  alias Jeopardy.GameStruct

  def create_game(game_id, players) do
    game_initial_data = GameStruct.new(game_id, players)

    DynamicSupervisor.start_child(
      Jeopardy.DynamicSupervisor,
      {Jeopardy.GameAgent, fn -> game_initial_data end}
    )
  end
end
