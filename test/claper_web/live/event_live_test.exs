defmodule ClaperWeb.EventLiveTest do
  use ClaperWeb.ConnCase

  import Phoenix.LiveViewTest
  import Claper.{PresentationsFixtures}

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

    test "deletes event in listing", %{conn: conn, presentation_file: presentation_file} do
      {:ok, index_live, _html} = live(conn, ~p"/events/#{presentation_file.event.uuid}/edit")

      {:ok, conn} =
        index_live
        |> element(~s{a[phx-click="delete"][phx-value-id=#{presentation_file.event.uuid}]})
        |> render_click()
        |> follow_redirect(conn, ~p"/events")

      {:ok, index_live, _html} = live(conn, ~p"/events")

      refute has_element?(index_live, "#event-#{presentation_file.event.uuid}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_event]

    test "displays event", %{conn: conn, presentation_file: presentation_file} do
      {:ok, _show_live, html} =
        live(conn, ~p"/e/#{presentation_file.event.code}")

      assert html =~ "Be the first to react !"
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
