defmodule ClaperWeb.StatControllerTest do
  use ClaperWeb.ConnCase

  import Claper.AccountsFixtures
  import Claper.PresentationsFixtures

  describe "export_transcriptions/2" do
    test "exports timestamp, language, and text as CSV", %{conn: conn} do
      user = confirmed_user_fixture()
      presentation_file = presentation_file_fixture(%{user: user}, [:event])

      {:ok, transcription} =
        Claper.Transcriptions.create_transcription(%{
          presentation_file_id: presentation_file.id,
          language: "en",
          text: "Welcome to the event"
        })

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/export/#{presentation_file.event.uuid}/transcriptions")

      assert response(conn, 200) =~
               "Timestamp (UTC),Language,Text\r\n#{Calendar.strftime(transcription.inserted_at, "%Y-%m-%d %H:%M:%S")},en,Welcome to the event"
    end

    test "rejects users without access", %{conn: conn} do
      owner = confirmed_user_fixture()
      unauthorized_user = confirmed_user_fixture()
      presentation_file = presentation_file_fixture(%{user: owner}, [:event])

      conn =
        conn
        |> log_in_user(unauthorized_user)
        |> post(~p"/export/#{presentation_file.event.uuid}/transcriptions")

      assert response(conn, 403) == "Forbidden"
    end
  end
end
