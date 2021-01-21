defmodule Jeopardy.GameAgent do
  use Agent
  alias Jeopardy.GameCatalog
  alias Jeopardy.Core

  def start_link(fun) do
    Agent.start_link(fun)
  end

  def select_question(game_id, category, points) do
    game_id
    |> update_data(fn game ->
      Core.select_question(game, category, points)
    end)
  end

  def user_answered(game_id, user_id) do
    game_id
    |> update_data(fn game -> Core.user_answered(game, user_id) end)
  end

  def get_scores(game_id) do
    access_data(game_id, fn game -> game.scores end, 0)
  end

  def get_board(game_id) do
    access_data(game_id, fn game -> game.board end, 0)
  end

  def get_current_selected(game_id) do
    access_data(game_id,
      fn game ->
        game.selected
      end,
      ""
    )
  end

  defp update_data(game_id, func) do
    agent_pid = GameCatalog.get_game_agent_pid(game_id)

    Agent.update(
      agent_pid,
      func
    )
  end

  defp access_data(game_id, func, default) do
    case GameCatalog.get_game_agent_pid(game_id) do
      nil -> default
      agent_pid -> Agent.get(agent_pid, func)
    end
  end
end
