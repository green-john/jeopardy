defmodule Jeopardy.GameStruct do
  alias Jeopardy.Board

  defstruct players: [],
            game_id: "",
            scores: %{},
            board: %Board{},
            selected: nil

  @type t :: %__MODULE__{
          players: [non_neg_integer],
          scores: %{
            non_neg_integer => non_neg_integer
          },
          board: Board.t(),
          selected: nil | [q: String.t(), a: String.t(), points: non_neg_integer]
        }

  @spec new(String.t(), list(String.t())) :: Jeopardy.GameStruct.t()
  def new(game_id, players) when is_list(players) do
    %__MODULE__{
      game_id: game_id,
      players: players,
      scores: for(p <- players, into: %{}, do: {p, 0}),
      board: Board.new(),
      selected: nil
    }
  end
end
