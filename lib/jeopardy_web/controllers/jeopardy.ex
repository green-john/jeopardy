defmodule JeopardyWeb.JeopardyController do
  use JeopardyWeb, :controller
  alias Jeopardy.GameCatalog
  alias JeopardyWeb.JeopardyLive

  import Phoenix.LiveView.Controller

  def create_game(conn, _params) do
    game_id = gen_random_url()
    GameCatalog.load_or_create_game(game_id, ["p1"])

    redirect(conn, to: Routes.jeopardy_path(conn, :resume_game, game_id))
  end

  def resume_game(conn, %{"game_id" => game_id}) do
    if GameCatalog.game_exists?(game_id) do
      live_render(
        conn,
        JeopardyLive,
        session: %{
          "game_id" => game_id
        }
      )
    else
      redirect(conn, to: Routes.jeopardy_path(conn, :create_game))
    end
  end

  defp get_range(length) when length > 1, do: 1..length
  defp get_range(_length), do: [1]

  defp gen_random_url() do
    length = 10
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    lists =
      (alphabets <> String.downcase(alphabets))
      |> String.split("", trim: true)

    get_range(length)
    |> Enum.reduce([], fn _, acc -> [Enum.random(lists) | acc] end)
    |> Enum.join("")
  end
end
