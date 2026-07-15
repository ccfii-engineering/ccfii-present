defmodule ClaperWeb.EventLive.ShowTest do
  use ClaperWeb.ConnCase

  import Phoenix.LiveViewTest
  import Claper.PresentationsFixtures

  setup [:register_and_log_in_user]

  test "renders attendee menus above inputs and delegates nickname closing to the hook", %{
    conn: conn,
    user: user
  } do
    presentation_file = presentation_file_fixture(%{user: user}, [:event])
    presentation_state_fixture(%{presentation_file: presentation_file})

    {:ok, _view, html} = live(conn, ~p"/e/#{presentation_file.event.code}")

    document = Floki.parse_document!(html)

    assert "z-50" in classes(document, "#side-menu-shadow")
    assert "z-[60]" in classes(document, "#side-menu")

    [close_command] = Floki.attribute(document, "#nicknamepicker", "data-close")

    assert [["toggle", %{"to" => "#nickname-popup"} = options]] = Jason.decode!(close_command)
    assert options["display"] == "flex"
    assert Floki.attribute(document, "#nicknamepicker", "phx-click") == []
  end

  defp classes(document, selector) do
    document
    |> Floki.attribute(selector, "class")
    |> List.first()
    |> String.split()
  end
end
