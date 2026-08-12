defmodule ClaperWeb.AdminLive.AdminShowTest do
  @moduledoc """
  Covers the unified admin "details card" presentation shared by the
  audit log, user, and event admin show pages.
  """

  use ClaperWeb.ConnCase

  import Phoenix.LiveViewTest
  import Claper.AccountsFixtures
  import Claper.AuditFixtures
  import Claper.EventsFixtures

  alias Claper.Accounts
  alias Claper.Repo

  alias ClaperWeb.AdminLive.{
    ModalComponent,
    SearchFilterComponent,
    TableActionsComponent,
    TableComponent
  }

  defp role_fixture(name) do
    Accounts.get_role_by_name(name) ||
      case Accounts.create_role(%{name: name}) do
        {:ok, role} -> role
        {:error, _changeset} -> Accounts.get_role_by_name(name)
      end
  end

  defp register_and_log_in_admin(%{conn: conn}) do
    role_fixture("user")
    role_fixture("admin")

    user = confirmed_user_fixture()
    {:ok, user} = Accounts.assign_role(user, "admin")

    %{conn: log_in_user(conn, user), admin: user}
  end

  describe "shared admin chrome" do
    test "renders search and filter controls with semantic surfaces and focus colors" do
      document =
        SearchFilterComponent
        |> render_component(
          id: "semantic-search",
          search_value: "Ada",
          filters: [
            %{name: "role", label: "Role", options: [{"Admin", "admin"}]}
          ],
          filter_values: %{"role" => "admin"},
          show_clear: true,
          export_csv_enabled: true,
          new_path: "/admin/users/new"
        )
        |> Floki.parse_document!()

      assert "bg-base-100" in classes(document, "div")
      assert "border-base-300" in classes(document, "div")
      assert "bg-base-100" in classes(document, ~s(input[name="search"]))
      assert "text-base-content" in classes(document, ~s(input[name="search"]))
      assert "border-neutral-400" in classes(document, ~s(input[name="search"]))
      assert "border-neutral-400" in classes(document, ~s(select[name="role"]))
      assert "focus:ring-secondary" in classes(document, ~s(input[name="search"]))
      assert "bg-primary" in classes(document, ~s(button[type="submit"]))
      assert "text-primary-content" in classes(document, ~s(button[type="submit"]))

      html = Floki.raw_html(document)
      refute html =~ "indigo-"
      refute html =~ "bg-white"
      refute html =~ "border-gray-"
    end

    test "renders tables and pagination with semantic base tokens" do
      document =
        TableComponent
        |> render_component(
          id: "semantic-table",
          headers: [%{label: "Name", field: "name", sortable: true}],
          rows: [["Ada"]],
          sortable: true,
          sort_config: %{field: "name", direction: :asc},
          pagination: %{
            page_number: 1,
            page_size: 10,
            total_entries: 11,
            total_pages: 2
          }
        )
        |> Floki.parse_document!()

      assert "divide-base-300" in classes(document, "table")
      assert "bg-base-200" in classes(document, "thead")
      assert "bg-base-100" in classes(document, "tbody")
      assert "text-base-content/70" in classes(document, "tbody td")
      assert "bg-base-100" in classes(document, "div.border-t")
      assert "border-base-300" in classes(document, "div.border-t")

      html = Floki.raw_html(document)
      assert html =~ "border-secondary"
      assert html =~ "bg-secondary"
      assert html =~ "text-secondary-content"
      refute html =~ "indigo-"
      refute html =~ "bg-white"
      refute html =~ "border-gray-"
    end

    test "uses native controls for sortable headers and row actions" do
      document =
        TableComponent
        |> render_component(
          id: "keyboard-table",
          headers: [
            %{label: "Name", field: "name", sortable: true},
            %{label: "Role", field: "role", sortable: true}
          ],
          rows: [["Ada", "Admin"]],
          sortable: true,
          row_click_enabled: true,
          sort_config: %{field: "name", direction: :desc}
        )
        |> Floki.parse_document!()

      assert Floki.attribute(document, ~s(th[aria-sort="descending"]), "aria-sort") == [
               "descending"
             ]

      assert Floki.attribute(document, ~s(th[aria-sort="none"]), "aria-sort") == ["none"]

      assert Floki.attribute(document, ~s(th button[phx-click="sort"]), "type") == [
               "button",
               "button"
             ]

      assert Floki.attribute(document, ~s(th button[phx-click="sort"]), "phx-keydown") == []
      assert Floki.attribute(document, ~s(tbody tr[phx-click="row_clicked"]), "role") == []
      assert Floki.attribute(document, ~s(tbody tr[phx-click="row_clicked"]), "tabindex") == []
      assert Floki.attribute(document, ~s(tbody tr[phx-click="row_clicked"]), "phx-keydown") == []

      assert Floki.attribute(
               document,
               ~s(tbody td:first-child button[phx-click="row_clicked"]),
               "type"
             ) == [
               "button"
             ]

      assert document |> Floki.find(~s(tbody td:first-child button)) |> Floki.text() =~ "View"
    end

    test "sort and row click events preserve their parent messages" do
      socket = %Phoenix.LiveView.Socket{
        assigns: %{
          __changed__: %{},
          sort_config: %{field: "name", direction: :asc},
          rows: [["Ada"]]
        }
      }

      assert {:noreply, sorted_socket} =
               TableComponent.handle_event("sort", %{"field" => "name"}, socket)

      assert_receive {:table_sort_changed, %{field: "name", direction: :desc}}
      assert sorted_socket.assigns.sort_config == %{field: "name", direction: :desc}

      assert {:noreply, ^socket} =
               TableComponent.handle_event("row_clicked", %{"row-index" => "0"}, socket)

      assert_receive {:table_row_clicked, ["Ada"], 0}
    end

    test "uses contrast-safe disabled pagination and empty-state colors" do
      document =
        TableComponent
        |> render_component(
          id: "disabled-table",
          headers: [%{label: "Name", field: "name", sortable: true}],
          rows: [],
          sortable: true,
          sort_config: %{field: nil, direction: :asc},
          empty_icon: "fas fa-inbox",
          pagination: %{
            page_number: 1,
            page_size: 10,
            total_entries: 0,
            total_pages: 1
          }
        )
        |> Floki.parse_document!()

      disabled_classes = Floki.attribute(document, ~s(span.cursor-not-allowed), "class")
      assert disabled_classes != []
      assert Enum.all?(disabled_classes, &String.contains?(&1, "text-neutral-400"))
      refute Enum.any?(disabled_classes, &String.contains?(&1, "text-base-content/30"))
      assert "text-neutral-400" in classes(document, ".fa-sort")
      assert "text-neutral-400" in classes(document, ".fa-inbox")
      assert Floki.find(document, "tbody td") |> Floki.text() =~ "No items found"
    end

    test "renders table actions with contrast-safe states and popup semantics" do
      actions_html =
        render_component(TableActionsComponent,
          id: "semantic-actions",
          item: %{name: "Ada"},
          item_id: 1,
          view_enabled: true,
          edit_enabled: true,
          delete_enabled: true,
          duplicate_enabled: true,
          archive_enabled: true,
          item_archived: true,
          toggle_enabled: true,
          item_active: true,
          dropdown_open: true,
          dropdown_actions: [
            %{key: "destroy", label: "Destroy", type: "danger"},
            %{key: "warn", label: "Warn", type: "warning"},
            %{key: "inspect", label: "Inspect", type: "default"}
          ]
        )

      actions_document = Floki.parse_document!(actions_html)

      assert "text-secondary" in classes(actions_document, ~s(button[title="View"]))
      assert "text-secondary" in classes(actions_document, ~s(button[title="Edit"]))
      assert "text-supporting-red-200" in classes(actions_document, ~s(button[title="Delete"]))

      assert "text-supporting-green-200" in classes(
               actions_document,
               ~s(button[title="Duplicate"])
             )

      assert "text-warning" in classes(actions_document, ~s(button[title="Unarchive"]))

      assert "text-supporting-green-200" in classes(
               actions_document,
               ~s(button[title="Deactivate"])
             )

      assert "bg-base-100" in classes(actions_document, "div.absolute")
      assert "border-base-300" in classes(actions_document, "div.absolute")

      assert "text-supporting-red-200" in classes(
               actions_document,
               ~s(button[phx-value-action="destroy"])
             )

      assert "text-warning" in classes(
               actions_document,
               ~s(button[phx-value-action="warn"])
             )

      assert "text-base-content" in classes(
               actions_document,
               ~s(button[phx-value-action="inspect"])
             )

      assert Floki.attribute(actions_document, ~s(button[title="More actions"]), "aria-expanded") ==
               [
                 "true"
               ]

      assert Floki.attribute(actions_document, ~s(button[title="More actions"]), "aria-controls") ==
               ["semantic-actions-actions"]

      assert Floki.attribute(actions_document, "#semantic-actions-actions", "role") == []

      assert Floki.attribute(actions_document, ~s(button[phx-click="dropdown_action"]), "role") ==
               []

      closed_document =
        TableActionsComponent
        |> render_component(
          id: "closed-actions",
          item: %{name: "Ada"},
          item_id: 1,
          dropdown_open: false,
          dropdown_actions: [%{key: "inspect", label: "Inspect", type: "default"}]
        )
        |> Floki.parse_document!()

      assert Floki.attribute(closed_document, ~s(button[title="More actions"]), "aria-expanded") ==
               [
                 "false"
               ]

      assert Floki.attribute(closed_document, ~s(button[title="More actions"]), "aria-controls") ==
               [
                 "closed-actions-actions"
               ]

      assert Floki.find(closed_document, "#closed-actions-actions") == []

      refute actions_html =~ "indigo-"
      refute actions_html =~ "bg-white"
    end

    test "archived, active, and default dropdown actions preserve parent messages" do
      socket = %Phoenix.LiveView.Socket{
        assigns: %{
          __changed__: %{},
          id: "behavior-actions",
          item: %{name: "Ada"},
          item_id: 7,
          item_archived: true,
          item_active: true,
          dropdown_open: true,
          dropdown_actions: [%{key: "view", label: "View", type: "default"}]
        }
      }

      assert {:noreply, ^socket} = TableActionsComponent.handle_event("archive_item", %{}, socket)
      assert_receive {:table_action, :unarchive, %{name: "Ada"}, 7}

      assert {:noreply, ^socket} = TableActionsComponent.handle_event("toggle_item", %{}, socket)
      assert_receive {:table_action, :deactivate, %{name: "Ada"}, 7}

      assert {:noreply, closed_socket} =
               TableActionsComponent.handle_event(
                 "dropdown_action",
                 %{"action" => "view"},
                 socket
               )

      assert_receive {:table_action, :view, %{name: "Ada"}, 7}
      refute closed_socket.assigns.dropdown_open
    end

    test "renders modal presets with contrast-safe content pairs" do
      for {id, config, background, foreground, confirm_content} <- [
            {"delete-modal", ModalComponent.delete_modal_config("Delete", "Danger"), "bg-error",
             "text-error-content", "text-error-content"},
            {"warning-modal", ModalComponent.warning_modal_config("Warning", "Caution"),
             "bg-warning/15", "text-warning", "text-warning-content"},
            {"info-modal", ModalComponent.info_modal_config("Information", "Semantic modal"),
             "bg-info/15", "text-info", "text-info-content"}
          ] do
        modal_html =
          render_component(
            ModalComponent,
            Map.merge(config, %{id: id, show: true})
          )

        modal_document = Floki.parse_document!(modal_html)

        assert background in classes(modal_document, ".rounded-full")
        assert foreground in classes(modal_document, ".rounded-full i")
        assert confirm_content in classes(modal_document, ~s(button[phx-click="confirm"]))
        assert "text-neutral-400" in classes(modal_document, "p")
      end
    end
  end

  describe "audit log show" do
    setup [:register_and_log_in_admin]

    test "renders the shared details card with all log fields", %{conn: conn} do
      log =
        log_fixture(%{
          action: "user.login",
          resource_type: "user",
          resource_id: 4242,
          metadata: %{"ip_address" => "127.0.0.1"}
        })

      {:ok, view, html} = live(conn, ~p"/admin/audit_logs/#{log.id}")

      # Shared details card shell
      assert has_element?(view, "dl.card.card-body")
      assert has_element?(view, "dl.card dt", "Action")
      assert has_element?(view, "dl.card dt", "Timestamp")
      assert has_element?(view, "dl.card dt", "Metadata")

      # Preserved semantics: action badge, resource fields, metadata
      assert html =~ "badge"
      assert html =~ "user.login"
      assert html =~ "Resource Type"
      assert html =~ "user"
      assert html =~ "4242"
      assert html =~ "ip_address"
      assert html =~ "127.0.0.1"
    end

    test "omits resource rows when the log has none", %{conn: conn} do
      log = log_fixture(%{resource_type: nil, resource_id: nil, metadata: %{}})

      {:ok, _view, html} = live(conn, ~p"/admin/audit_logs/#{log.id}")

      refute html =~ "Resource Type"
      refute html =~ "Resource ID"
      # Empty metadata renders as the shared placeholder.
      assert html =~ "—"
    end
  end

  describe "user show" do
    setup [:register_and_log_in_admin]

    test "renders the shared details card with confirmed status badge", %{conn: conn} do
      user = confirmed_user_fixture()

      {:ok, view, html} = live(conn, ~p"/admin/users/#{user.id}")

      assert has_element?(view, "dl.card.card-body")
      assert has_element?(view, "dl.card dt", "First name")
      assert has_element?(view, "dl.card dt", "Last name")
      assert has_element?(view, "dl.card dt", "Email")
      assert has_element?(view, "dl.card dt", "Status")
      assert has_element?(view, "dl.card dt", "Confirmed At")

      assert html =~ user.email
      assert html =~ user.first_name
      assert html =~ user.last_name
      assert html =~ "badge badge-success"
      assert html =~ "Confirmed"
    end

    test "renders unconfirmed badge and hides confirmed at row when missing", %{conn: conn} do
      user = user_fixture()

      {:ok, _view, html} = live(conn, ~p"/admin/users/#{user.id}")

      assert html =~ "badge badge-warning"
      assert html =~ "Unconfirmed"
      refute html =~ "Confirmed At"
    end

    test "renders the audit log section scoped to the user with row links", %{conn: conn} do
      user = confirmed_user_fixture()
      other = confirmed_user_fixture()

      log =
        log_fixture(%{
          user_id: user.id,
          action: "user.login",
          metadata: %{"ip_address" => "10.0.0.1"}
        })

      other_log =
        log_fixture(%{
          user_id: other.id,
          action: "other.action",
          metadata: %{"ip_address" => "10.0.0.2"}
        })

      {:ok, view, html} = live(conn, ~p"/admin/users/#{user.id}")

      assert html =~ "Audit Logs"
      assert html =~ "user.login"
      refute html =~ "other.action"
      assert html =~ "ip_address: 10.0.0.1"

      assert has_element?(
               view,
               ~s|a[href="/admin/audit_logs/#{log.id}"]|
             )

      refute has_element?(
               view,
               ~s|a[href="/admin/audit_logs/#{other_log.id}"]|
             )
    end

    test "renders the empty state when the user has no audit logs", %{conn: conn} do
      user = confirmed_user_fixture()

      {:ok, _view, html} = live(conn, ~p"/admin/users/#{user.id}")

      assert html =~ "Audit Logs"
      assert html =~ "No audit logs for this user."
    end

    test "paginates the user's audit logs", %{conn: conn} do
      user = confirmed_user_fixture()

      logs =
        for index <- 1..3 do
          log_fixture(%{user_id: user.id, action: "user.action.#{index}"})
        end

      {:ok, _view, page_1_html} =
        live(conn, ~p"/admin/users/#{user.id}?#{[page: 1, page_size: 2]}")

      {:ok, _view, page_2_html} =
        live(conn, ~p"/admin/users/#{user.id}?#{[page: 2, page_size: 2]}")

      page_1_matches =
        Enum.count(logs, fn log -> page_1_html =~ log.action end)

      page_2_matches =
        Enum.count(logs, fn log -> page_2_html =~ log.action end)

      assert page_1_matches == 2
      assert page_2_matches == 1
    end
  end

  describe "user form" do
    setup [:register_and_log_in_admin]

    test "renders first and last name fields", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/users/new")

      assert has_element?(view, "#user-form input[name='user[first_name]']")
      assert has_element?(view, "#user-form input[name='user[last_name]']")
    end

    test "creates a user with names", %{conn: conn} do
      role = Accounts.get_role_by_name("user")
      email = unique_user_email()
      {:ok, view, _html} = live(conn, ~p"/admin/users/new")

      view
      |> form("#user-form", %{
        "user" => %{
          "first_name" => "Admin",
          "last_name" => "Created",
          "email" => email,
          "password" => valid_user_password(),
          "role_id" => role.id
        }
      })
      |> render_submit()

      assert_redirect(view, ~p"/admin/users")
      user = Accounts.get_user_by_email(email)
      assert user.first_name == "Admin"
      assert user.last_name == "Created"
    end

    test "updates a user's names", %{conn: conn} do
      user = confirmed_user_fixture()
      {:ok, view, _html} = live(conn, ~p"/admin/users/#{user.id}/edit")

      view
      |> form("#user-form", %{
        "user" => %{
          "first_name" => "Admin",
          "last_name" => "Updated",
          "email" => user.email,
          "role_id" => user.role_id
        }
      })
      |> render_submit()

      assert_redirect(view, ~p"/admin/users")
      updated_user = Accounts.get_user!(user.id)
      assert updated_user.first_name == "Admin"
      assert updated_user.last_name == "Updated"
    end
  end

  describe "event show" do
    setup [:register_and_log_in_admin]

    test "renders the shared details card with owner and timestamps", %{conn: conn} do
      owner = user_fixture(%{email: "owner-#{System.unique_integer([:positive])}@example.com"})

      event =
        event_fixture(%{
          user: owner,
          name: "Admin Show Event",
          started_at: ~N[2026-04-01 10:00:00],
          expired_at: ~N[2026-04-02 10:00:00]
        })

      {:ok, view, html} = live(conn, ~p"/admin/events/#{event.id}")

      assert has_element?(view, "dl.card.card-body")
      assert has_element?(view, "dl.card dt", "Owner")
      assert has_element?(view, "dl.card dt", "Started At")
      assert has_element?(view, "dl.card dt", "Expired At")

      assert html =~ "Admin Show Event"
      assert html =~ owner.email
      assert html =~ "2026-04-01"
      assert html =~ "2026-04-02"
    end

    test "preserves owner and expiration fallbacks when fields are missing", %{conn: conn} do
      # event_fixture creates an owner; bypass the changeset to null
      # user_id and expired_at so we can exercise the fallback strings.
      # started_at is non-null at the DB level so we leave it set.
      event = event_fixture(%{expired_at: nil})

      {1, _} =
        Repo.update_all(
          Ecto.Query.from(e in Claper.Events.Event, where: e.id == ^event.id),
          set: [user_id: nil]
        )

      {:ok, _view, html} = live(conn, ~p"/admin/events/#{event.id}")

      assert html =~ "No owner"
      assert html =~ "Not expired"
    end
  end

  defp classes(document, selector) do
    document
    |> Floki.attribute(selector, "class")
    |> List.first()
    |> String.split()
  end
end
