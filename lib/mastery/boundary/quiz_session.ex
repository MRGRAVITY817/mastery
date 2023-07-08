defmodule Mastery.Boundary.QuizSession do
  alias Mastery.Core.{Quiz, Response}
  use GenServer

  # Each user will have their own process
  def init({quiz, email}) do
    {:ok, {quiz, email}}
  end

  def handle_call(:select_question, _from, {quiz, email}) do
    quiz = Quiz.select_question(quiz)
    {:reply, quiz.current_question.asked, {quiz, email}}
  end

  def handle_call({:answer_question, answer}, _from, {quiz, email}) do
    quiz
    |> Quiz.answer_question(Response.new(quiz, email, answer))
    |> Quiz.select_question()
    |> maybe_finish(email)
  end

  # If there's no question to proceed, it's finished.
  # We will :stop the GenServer in :normal way of termination.
  defp maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  # If there's more to go, give question.
  defp maybe_finish(quiz, email) do
    {
      :reply,
      {quiz.current_question.asked, quiz.last_response.correct},
      {quiz, email}
    }
  end

  # Service APIs

  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  def answer_question(session, answer) do
    GenServer.call(session, {:answer_question, answer})
  end

  # Lifecycle

  def child_spec({quiz, email}) do
    %{
      # An unique identifier, to differ from other siblings.
      id: {__MODULE__, {quiz.title, email}},
      # OTP will invoke `QuizSession.start_link({quiz, email})` 
      start: {__MODULE__, :start_link, [{quiz, email}]},
      # Supervisor should do nothing when process crashes,
      # user should restart the process.
      restart: :temporary
    }
  end
end
