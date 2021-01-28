defmodule Jeopardy.Core do
  def extract_question(board, category, points) when is_integer(points) do

    case Map.has_key?(board.questions, category) do
      true ->
        q_in_cat = board.questions[category]
        qa = Map.get(q_in_cat, points, [])
        questions = Map.put(board.questions, category, Map.delete(q_in_cat, points))

        {
          %{board | questions: questions},
          qa
        }

      false ->
        {board, []}
    end
  end

  def question_available?(board, category, points) do
    # IO.inspect(game)

    case Map.get(board.questions, category) do
      nil ->
        false

      _questions ->
        case Map.get(board.questions[category], points) do
          nil -> false
          _qa -> true
        end
    end
  end

  def select_question(game, category, points) do
    {board, [q: q, a: a]} = extract_question(game.board, category, points)
    %{game | board: board, selected: [q: q, a: a, points: points]}
  end

  def user_answered(game, user_id) do
    [_, _, points: points] = game.selected
    scores = Map.update(game.scores, user_id, 0, &(&1 + points))
    %{game | scores: scores, selected: nil}
  end
end
