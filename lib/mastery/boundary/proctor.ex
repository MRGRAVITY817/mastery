defmodule Mastery.Boundary.Proctor do
  use GenServer
  require Logger
  alias Mastery.Boundary.{QuizManager, QuizSession}

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  def init(quizzes) do
    {:ok, quizzes}
  end

  def schedule_quiz(proctor \\ __MODULE__, quiz, templates, start_at, end_at) do
    quiz = %{
      fields: quiz,
      templates: templates,
      start_at: start_at,
      end_at: end_at
    }

    GenServer.call(proctor, {:schedule_quiz, quiz})
  end
end
