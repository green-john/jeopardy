defmodule Jeopardy.Board do
  defstruct categories: [],
            questions: %{}

  @type t :: %__MODULE__{
          categories: [String.t()],
          questions: %{
            String.t() => %{
              non_neg_integer => [
                q: String.t(),
                a: String.t()
              ]
            }
          }
        }

  def new() do
    {categories, all_questions} = generalTrivia()

    cat_questions =
      all_questions
      |> Enum.chunk_every(5)
      |> Enum.zip(categories)

    questions =
      for {questions, cat} <- cat_questions,
          into: %{},
          do: {cat, questions_to_posts(questions)}

    %__MODULE__{
      categories: categories,
      questions: questions
    }
  end

  defp questions_to_posts(questions) do
    for {{q, a}, idx} <- Enum.with_index(questions),
        into: %{},
        do: {(idx + 1) * 100, [q: q, a: a]}
  end

  defp generalTrivia do
    {
      ["Geology", "Cat2", "Cat3", "Cat4", "Cat5"],
      [
        {
          "Fissures, vents and plugs are all associated with this natural geological feature.",
          "What are volcanoes?"
        },
        {
          "What is the most abundant metal in the earth's crust",
          "What is Aluminium"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "Fissures, vents and plugs are all associated with this natural geological feature.",
          "What are volcanoes?"
        },
        {
          "What is the most abundant metal in the earth's crust",
          "What is Aluminium"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "Fissures, vents and plugs are all associated with this natural geological feature.",
          "What are volcanoes?"
        },
        {
          "What is the most abundant metal in the earth's crust",
          "What is Aluminium"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "Fissures, vents and plugs are all associated with this natural geological feature.",
          "What are volcanoes?"
        },
        {
          "What is the most abundant metal in the earth's crust",
          "What is Aluminium"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "Fissures, vents and plugs are all associated with this natural geological feature.",
          "What are volcanoes?"
        },
        {
          "What is the most abundant metal in the earth's crust",
          "What is Aluminium"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        },
        {
          "What color is a polar bear's skin?",
          "What is black"
        }
      ]
    }
  end
end
