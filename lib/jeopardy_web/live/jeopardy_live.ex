defmodule JeopardyWeb.JeopardyLive do
  use JeopardyWeb, :live_view

  alias Jeopardy.GameAgent
  alias Jeopardy.Core

  def mount(_params, %{"game_id" => game_id}, socket) do
    {:ok,
     assign(socket,
       game_id: game_id,
       board: GameAgent.get_board(game_id),
       scores: GameAgent.get_scores(game_id),
       selected: GameAgent.get_current_selected(game_id)
     )}
  end

  def handle_event(
        "select-question",
        %{"category" => category, "points" => points},
        socket
      ) do
    game_id = socket.assigns.game_id
    GameAgent.select_question(game_id, category, points)

    IO.inspect(GameAgent.get_current_selected(game_id))

    {:noreply,
     assign(socket,
       board: GameAgent.get_board(game_id),
       scores: GameAgent.get_scores(game_id),
       selected: GameAgent.get_current_selected(game_id)
     )}
  end

  def is_question_available?(board, category, points) do
    Core.question_available?(board, category, points)
  end
end
