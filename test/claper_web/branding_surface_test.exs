defmodule ClaperWeb.BrandingSurfaceTest do
  use ClaperWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Claper.AccountsFixtures
  import Claper.PresentationsFixtures

  alias Claper.Accounts
  alias Claper.Accounts.UserToken
  alias Claper.Repo

  @brand_logo "/images/ccfii-present-logo.png"
  @attribution "Powered by Claper"

  test "account login uses the CCFII Present identity", %{conn: conn} do
    html = conn |> get(~p"/users/log_in") |> html_response(200)

    assert html =~ "CCFII Present"
    assert html =~ @brand_logo
    assert html =~ "ccfii-auth-backdrop"
    assert html =~ @attribution
    assert title(html) == "CCFII Present"
    refute html =~ " · Claper"
  end

  test "password reset request and edit use the account-access branding", %{conn: conn} do
    request_html = conn |> get(~p"/users/reset_password") |> html_response(200)

    user = user_fixture()
    {token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)

    edit_html = conn |> get(~p"/users/reset_password/#{token}") |> html_response(200)

    for html <- [request_html, edit_html] do
      assert html =~ "CCFII Present"
      assert html =~ @brand_logo
      assert html =~ "ccfii-auth-backdrop"
      assert html =~ @attribution
    end
  end

  test "presenter dashboard uses branded chrome and upstream attribution", %{conn: conn} do
    user = confirmed_user_fixture()
    conn = log_in_user(conn, user)

    {:ok, _view, html} = live(conn, ~p"/events")

    assert html =~ "CCFII Present"
    assert html =~ @attribution
    assert title(html) == "Dashboard · CCFII Present"
    refute html =~ " · Claper"
  end

  test "admin chrome identifies CCFII Present Admin and includes attribution", %{conn: conn} do
    ensure_role("user")
    ensure_role("admin")

    user = confirmed_user_fixture()
    {:ok, user} = Accounts.assign_role(user, "admin")

    {:ok, _view, html} = conn |> log_in_user(user) |> live(~p"/admin")

    assert html =~ @attribution
    assert title(html) == "Dashboard · CCFII Present Admin"
    refute html =~ " · Claper Admin"
  end

  test "audience join and presentation content omit upstream attribution", %{conn: conn} do
    {:ok, _join_view, join_html} = live(conn, ~p"/")

    presentation_file = presentation_file_fixture(%{}, [:event])
    presentation_state_fixture(%{presentation_file: presentation_file})
    event = presentation_file.event

    {:ok, _event_view, event_html} = live(conn, ~p"/e/#{event.code}")

    for html <- [join_html, event_html] do
      refute html =~ @attribution
      refute html =~ "github.com/ClaperCo/Claper"
      refute html =~ "powered-by"
    end
  end

  test "serves the Apple touch icon referenced by layouts", %{conn: conn} do
    conn = get(conn, "/apple-touch-icon.png")

    assert response(conn, 200) != ""
    assert get_resp_header(conn, "content-type") == ["image/png"]
  end

  defp title(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find("title")
    |> Floki.text()
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
  end

  defp ensure_role(name) do
    Accounts.get_role_by_name(name) ||
      case Accounts.create_role(%{name: name}) do
        {:ok, role} -> role
        {:error, _changeset} -> Accounts.get_role_by_name(name)
      end
  end
end
