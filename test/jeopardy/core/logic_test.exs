defmodule Jeopardy.CoreTest do
  use ExUnit.Case

  alias Jeopardy.Board
  alias Jeopardy.GameStruct
  alias Jeopardy.Core

  test "create empty board" do
    board = %Board{}

    assert board.categories == []
    assert board.questions == %{}
  end

  test "create board with one categories" do
    board = Board.new()

    assert List.first(board.categories) == "Geology"

    questions = Map.get(board.questions, "Geology")

    assert map_size(questions) == 5

    [q: q, a: a] = Map.get(questions, 100)
    assert is_bitstring(q)
    assert is_bitstring(a)
  end

  test "take question from board" do
    board = Board.new()

    {board, [q: q, a: a]} = Core.extract_question(board, "Geology", 100)
    assert is_bitstring(q)
    assert is_bitstring(a)

    questions = Map.get(board.questions, "Geology")
    assert map_size(questions) == 4

    assert Map.get(questions, 100) == nil
  end

  test "create a new game" do
    game = GameStruct.new("g1", ["a", "b"])
    assert length(game.players) == 2
    assert map_size(game.scores) == 2

    assert Core.question_available?(game.board, "Geology", 100)
  end

  test "play first turn (select square)" do
    game = GameStruct.new("g1", ["a", "b"])
    game = Core.select_question(game, "Geology", 100)
    [q: q, a: a, points: points] = game.selected
    assert is_bitstring(q)
    assert is_bitstring(a)
    assert points == 100
    assert not Core.question_available?(game.board, "Geology", 100)
  end

  test "play second turn (select turn)" do
    game =
      GameStruct.new("g1", ["a", "b"])
      |> Core.select_question("Geology", 100)
      |> Core.user_answered("a")

    assert game.selected == nil
    assert game.scores["a"] == 100
    assert not Core.question_available?(game.board, "Geology", 100)
  end

  test "play multiple turns" do
    game =
      GameStruct.new("g1", ["a", "b"])
      |> Core.select_question("Geology", 100)
      |> Core.user_answered("a")
      |> Core.select_question("Geology", 200)
      |> Core.user_answered("b")
      |> Core.select_question("Geology", 300)
      |> Core.user_answered("a")

    assert game.selected == nil
    assert game.scores["a"] == 400
    assert game.scores["b"] == 200

    assert not Core.question_available?(game.board, "Geology", 100)
    assert not Core.question_available?(game.board, "Geology", 200)
    assert not Core.question_available?(game.board, "Geology", 300)
  end
end
