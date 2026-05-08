defmodule ClaperWeb.StatControllerTest do
  use ClaperWeb.ConnCase, async: true

  import Claper.{AccountsFixtures, FormsFixtures, PresentationsFixtures}

  describe "POST /export/forms/:form_id" do
    setup %{conn: conn} do
      owner = confirmed_user_fixture()
      presentation_file = presentation_file_fixture(%{user: owner}, [:event])

      form =
        form_fixture(%{
          presentation_file_id: presentation_file.id,
          title: "My Form",
          fields: [
            %{name: "First Name", type: "text", required: false},
            %{name: "Email Address", type: "email", required: false}
          ]
        })

      %{conn: log_in_user(conn, owner), form: form, event: presentation_file.event}
    end

    test "exports CSV with field names containing spaces as headers and values", %{
      conn: conn,
      form: form,
      event: event
    } do
      {:ok, _submit} =
        Claper.Forms.create_or_update_form_submit(event.uuid, %{
          "attendee_identifier" => "attendee-1",
          "form_id" => form.id,
          "response" => %{"First Name" => "Ada", "Email Address" => "ada@example.com"}
        })

      conn = post(conn, ~p"/export/forms/#{form.id}")

      assert response_content_type(conn, :csv)
      body = response(conn, 200)

      [header_line, data_line | _] = String.split(body, "\r\n", trim: true)

      assert header_line =~ "First Name"
      assert header_line =~ "Email Address"

      # The CSV row must contain the values, proving header→response key
      # alignment works for space-containing field names. Regression: when
      # submissions were saved under a wrong key, the CSV row was empty.
      assert data_line =~ "Ada"
      assert data_line =~ "ada@example.com"
    end

    test "returns 403 for users who don't own the event", %{form: form} do
      stranger = confirmed_user_fixture()
      conn = build_conn() |> log_in_user(stranger)

      conn = post(conn, ~p"/export/forms/#{form.id}")

      assert response(conn, 403) == "Forbidden"
    end
  end
end
