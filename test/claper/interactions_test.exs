defmodule Claper.InteractionsTest do
  use Claper.DataCase

  alias Claper.Interactions

  import Claper.{EventsFixtures, PollsFixtures, PresentationsFixtures, QuizzesFixtures}

  describe "move_interaction/3" do
    setup do
      event = event_fixture()
      presentation_file = presentation_file_fixture(%{event: event, length: 5})

      %{event: %{event | presentation_file: presentation_file}}
    end

    test "moves an interaction to another slide and disables it", %{event: event} do
      poll =
        poll_fixture(%{
          presentation_file_id: event.presentation_file.id,
          position: 0,
          enabled: true
        })

      assert {:ok, moved} = Interactions.move_interaction(event, poll, 3)
      assert moved.position == 3
      refute moved.enabled
      refute Claper.Polls.get_poll!(poll.id).enabled
    end

    test "moves a quiz without touching its questions", %{event: event} do
      quiz =
        quiz_fixture(%{
          presentation_file: event.presentation_file,
          position: 1,
          enabled: true
        })

      # Load through the same path as the manage LiveView: no preloads, so
      # quiz_questions is NotLoaded and must not be required by the update.
      quiz = Claper.Quizzes.get_quiz_for_event(quiz.id, event.id)

      assert {:ok, moved} = Interactions.move_interaction(event, quiz, 4)
      assert moved.position == 4
      refute moved.enabled
      assert length(Claper.Quizzes.get_quiz!(quiz.id, [:quiz_questions]).quiz_questions) == 1
    end

    test "is a no-op when the position is unchanged", %{event: event} do
      poll =
        poll_fixture(%{
          presentation_file_id: event.presentation_file.id,
          position: 2,
          enabled: true
        })

      assert {:ok, same} = Interactions.move_interaction(event, poll, 2)
      assert same.position == 2
      assert same.enabled
    end

    test "rejects out-of-range positions", %{event: event} do
      poll = poll_fixture(%{presentation_file_id: event.presentation_file.id, position: 0})

      assert {:error, :invalid_position} = Interactions.move_interaction(event, poll, -1)
      assert {:error, :invalid_position} = Interactions.move_interaction(event, poll, 5)
    end
  end
end
