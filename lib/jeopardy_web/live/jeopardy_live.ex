defmodule JeopardyWeb.JeopardyLive do
  use JeopardyWeb, :live_view

  alias Jeopardy.GameAgent
  alias Jeopardy.Core

  def mount(_params, %{"game_id" => game_id}, socket) do
    case GameAgent.get_selelected(game_id) do
      [q: q, a: a, points: points] ->  
        {:ok,
         assign(socket,
           game_id: game_id,
           board: GameAgent.get_board(game_id),
           scores: GameAgent.get_scores(game_id),
           showing_answer: true,
           selected_question: q,
           selected_answer: a,
           selected_points: points,
         )}

      nil -> 
        {:ok,
         assign(socket,
           game_id: game_id,
           board: GameAgent.get_board(game_id),
           scores: GameAgent.get_scores(game_id),
           showing_answer: false,
           selected_question: nil,
           selected_answer: nil,
           selected_points: nil,
         )}
    end
  end

  def handle_event(
        "select_question",
        %{"category" => category, "points" => points},
        socket
      ) do
    game_id = socket.assigns.game_id
    GameAgent.select_question(game_id, category, String.to_integer(points))

    IO.inspect(GameAgent.get_selelected(game_id))

    [q: q, a: a, points: points] = GameAgent.get_selelected(game_id)

    {:noreply,
     assign(socket,
       board: GameAgent.get_board(game_id),
       scores: GameAgent.get_scores(game_id),
       selected_question: q,
       selected_answer: a,
       selected_points: points,
     )}
  end

  def handle_event("toggle_show_answer", %{"key" => "Space"}, socket) do
    showing = socket.assigns.showing_answer
    {:noreply, assign(socket, showing_answer: not showing)}
  end
  def handle_event("toggle_show_answer-answer", _params, socket), do: {:noreply, socket}


  def is_question_available?(board, category, points) do
    Core.question_available?(board, category, points)
  end
end
