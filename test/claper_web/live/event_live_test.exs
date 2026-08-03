defmodule ClaperWeb.EventLiveTest do
  use ClaperWeb.ConnCase

  import Phoenix.LiveViewTest
  import Claper.{FormsFixtures, PresentationsFixtures}

  @update_attrs %{name: "some updated name"}

  defp create_event(params) do
    presentation_file = presentation_file_fixture(%{user: params.user}, [:event])
    presentation_state_fixture(%{presentation_file: presentation_file})
    params |> Map.put(:presentation_file, presentation_file)
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_event]

    test "lists all events", %{conn: conn, presentation_file: presentation_file} do
      {:ok, _index_live, html} = live(conn, ~p"/events")

      assert html =~ "events"
      assert html =~ presentation_file.event.name
    end

    test "updates event in listing", %{conn: conn, presentation_file: presentation_file} do
      {:ok, index_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/edit")

      {:ok, conn} =
        index_live
        |> form("#event-form", event: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/events")

      assert html_response(conn, 200) =~ "Updated successfully"
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders the redesigned create and edit states", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      {:ok, edit_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/edit")

      assert has_element?(edit_live, "#event-editor-title", "Edit event")
      assert has_element?(edit_live, "#presentation-heading", "Presentation")
      assert has_element?(edit_live, "#event-details-heading", "Event details")
      assert has_element?(edit_live, ~s(#date-picker input[type="datetime-local"]))

      assert has_element?(
               edit_live,
               ~s(#date-picker input[name="event[started_at]"][type="hidden"])
             )

      assert has_element?(edit_live, "#facilitators-section")
      assert has_element?(edit_live, "#event-danger-zone", "Delete event")
      assert has_element?(edit_live, ~s(button[form="event-form"]), "Save changes")

      {:ok, new_live, _html} = live(conn, ~p"/events/new")

      assert has_element?(new_live, "#event-editor-title", "Create event")
      assert has_element?(new_live, "#presentation-heading", "Presentation")
      assert has_element?(new_live, ~s(label[for]), "Choose file")
      refute has_element?(new_live, "#facilitators-section")
      refute has_element?(new_live, "#event-danger-zone")
      assert has_element?(new_live, ~s(button[form="event-form"]), "Create event")
    end

    test "adds and removes an unsaved facilitator", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      {:ok, index_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/edit")

      assert has_element?(index_live, "#facilitators-empty-state")

      index_live
      |> element(~s(button[phx-click="add-leader"]))
      |> render_click()

      refute has_element?(index_live, "#facilitators-empty-state")

      assert has_element?(
               index_live,
               ~S|#facilitators-section input[type="email"]:not([readonly])|
             )

      index_live
      |> element(~s(button[phx-click="remove-leader"]))
      |> render_click()

      assert has_element?(index_live, "#facilitators-empty-state")
    end

    test "disables save when event details are invalid", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      {:ok, index_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/edit")

      index_live
      |> form("#event-form", event: %{name: ""})
      |> render_change()

      assert has_element?(index_live, ~s(button[form="event-form"][disabled]))
    end

    test "deletes event in listing", %{conn: conn, presentation_file: presentation_file} do
      {:ok, index_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/edit")

      {:ok, conn} =
        index_live
        |> element(~s{a[phx-click="delete"][phx-value-id=#{presentation_file.event.uuid}]})
        |> render_click()
        |> follow_redirect(conn, ~p"/events")

      {:ok, index_live, _html} = live(conn, ~p"/events")

      refute has_element?(index_live, "#event-#{presentation_file.event.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_event]

    test "displays event", %{conn: conn, presentation_file: presentation_file} do
      {:ok, _show_live, html} =
        live(conn, ~p"/e/#{presentation_file.event.code}")

      assert html =~ "Be the first to ask a question or share a thought."
      assert html =~ presentation_file.event.name
    end
  end

  describe "Manage" do
    setup [:register_and_log_in_user, :create_event]

    test "prompts to regenerate missing thumbnails and starts regeneration", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      Oban.Testing.with_testing_mode(:manual, fn ->
        {:ok, manage_live, html} = live(conn, ~p"/e/#{presentation_file.event.code}/manage")

        assert html =~ "No thumbnails are available"
        assert html =~ "Regenerate thumbnails"

        manage_live
        |> element(~s{button[phx-click="regenerate-thumbnails"]})
        |> render_click()

        assert render(manage_live) =~ "Thumbnail regeneration started"
      end)
    end
  end

  describe "Stats" do
    setup [:register_and_log_in_user, :create_event]

    test "hides interaction tabs that have no content", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      {:ok, _stats_live, html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/stats")

      refute html =~ ~s(phx-value-tab="messages")
      refute html =~ ~s(phx-value-tab="polls")
      refute html =~ ~s(phx-value-tab="forms")
      refute html =~ ~s(phx-value-tab="web_content")
      refute html =~ ~s(phx-value-tab="quizzes")
      refute html =~ ~s(phx-value-tab="transcriptions")
    end

    test "displays transcriptions in report", %{conn: conn, presentation_file: presentation_file} do
      {:ok, _transcription} =
        Claper.Transcriptions.create_transcription(%{
          presentation_file_id: presentation_file.id,
          language: "en",
          text: "Welcome to the event"
        })

      {:ok, stats_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/stats")

      html =
        stats_live
        |> element(~s{button[phx-value-tab="transcriptions"]})
        |> render_click()

      assert html =~ "Transcriptions"
      assert html =~ "Welcome to the event"
      assert html =~ "UTC"
    end

    test "loads more transcriptions in report", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      for index <- 1..26 do
        {:ok, _transcription} =
          Claper.Transcriptions.create_transcription(%{
            presentation_file_id: presentation_file.id,
            language: "en",
            text: "Transcript segment #{index}"
          })
      end

      {:ok, stats_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/stats")

      html =
        stats_live
        |> element(~s{button[phx-value-tab="transcriptions"]})
        |> render_click()

      assert html =~ "Transcriptions"
      assert html =~ "Transcript segment 1"
      refute html =~ "Transcript segment 26"
      assert html =~ "Load more"

      html =
        stats_live
        |> element(~s{button[phx-click="load_more_transcriptions"]})
        |> render_click()

      assert html =~ "Transcript segment 1"
      assert html =~ "Transcript segment 26"
      refute html =~ "Load more"
    end

    test "displays emoji avatars for form submissions in report", %{
      conn: conn,
      presentation_file: presentation_file
    } do
      form = form_fixture(%{presentation_file_id: presentation_file.id})

      {:ok, _form_submit} =
        Claper.Forms.create_form_submit(%{
          form_id: form.id,
          attendee_identifier: "attendee-1",
          response: %{"Name" => "Ada"}
        })

      {:ok, stats_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/stats")

      html =
        stats_live
        |> element(~s{button[phx-value-tab="forms"]})
        |> render_click()

      assert html =~ "Ada"
      assert html =~ "avatar avatar-placeholder"
    end
  end

  describe "Join" do
    test "renders the join page", %{conn: conn} do
      {:ok, join_live, html} = live(conn, ~p"/")

      assert html =~ "Join the event"
      assert html =~ "Event code"
      assert html =~ "Are you a presenter?"
      assert html =~ "Start creating for free"
      refute html =~ "Turn your slides into conversations"

      assert has_element?(join_live, "#form")
      assert has_element?(join_live, "#input[placeholder='ABCD1234']")
    end
  end
end
