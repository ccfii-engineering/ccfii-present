defmodule ClaperWeb.AdminLive.TableComponent do
  use ClaperWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-base-300">
          <thead class="bg-base-200">
            <tr>
              <%= for {header, _index} <- Enum.with_index(@headers) do %>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-base-content/60 uppercase tracking-wider"
                  aria-sort={
                    if @sortable && header.sortable, do: aria_sort(@sort_config, header.field)
                  }
                >
                  <%= if @sortable && header.sortable do %>
                    <button
                      type="button"
                      class="flex w-full items-center text-left uppercase tracking-wider hover:text-base-content"
                      phx-click="sort"
                      phx-value-field={header.field}
                      phx-target={@myself}
                    >
                      {header.label}
                      <%= case @sort_config do %>
                        <% %{field: field, direction: :asc} when field == header.field -> %>
                          <i class="fas fa-sort-up ml-2 text-secondary"></i>
                        <% %{field: field, direction: :desc} when field == header.field -> %>
                          <i class="fas fa-sort-down ml-2 text-secondary"></i>
                        <% _ -> %>
                          <i class="fas fa-sort ml-2 text-neutral-400"></i>
                      <% end %>
                    </button>
                  <% else %>
                    <div class="flex items-center">
                      {if is_binary(header), do: header, else: header.label}
                    </div>
                  <% end %>
                </th>
              <% end %>
            </tr>
          </thead>
          <tbody class="bg-base-100 divide-y divide-base-300">
            <%= if length(@rows) > 0 do %>
              <%= for {row, row_index} <- Enum.with_index(@rows) do %>
                <tr
                  class={[
                    "hover:bg-base-200",
                    if(@row_click_enabled, do: "cursor-pointer", else: "")
                  ]}
                  phx-click={if @row_click_enabled, do: "row_clicked", else: nil}
                  phx-value-row-index={row_index}
                  phx-target={@myself}
                >
                  <%= for {cell_content, cell_index} <- Enum.with_index(get_row_cells(row, @headers, @row_func)) do %>
                    <td class="relative px-6 py-4 whitespace-nowrap text-sm text-base-content/70">
                      <button
                        :if={@row_click_enabled && cell_index == 0}
                        type="button"
                        class="sr-only focus:not-sr-only focus:absolute focus:left-2 focus:top-1/2 focus:z-10 focus:-translate-y-1/2 focus:rounded-md focus:bg-secondary focus:px-3 focus:py-2 focus:text-secondary-content focus:ring-2 focus:ring-secondary focus:ring-offset-2 focus:ring-offset-base-100"
                        phx-click="row_clicked"
                        phx-value-row-index={row_index}
                        phx-target={@myself}
                      >
                        View
                      </button>
                      <%= case cell_content do %>
                        <% {:safe, content} -> %>
                          {raw(content)}
                        <% content when is_binary(content) -> %>
                          {content}
                        <% content -> %>
                          {to_string(content)}
                      <% end %>
                    </td>
                  <% end %>
                </tr>
              <% end %>
            <% else %>
              <tr>
                <td
                  colspan={length(@headers)}
                  class="px-6 py-4 text-center text-sm text-base-content/70"
                >
                  <div class="flex flex-col items-center py-8">
                    <%= if @empty_icon do %>
                      <i class={"#{@empty_icon} text-neutral-400 text-4xl mb-4"}></i>
                    <% end %>
                    <p class="text-lg font-medium text-base-content mb-2">
                      {@empty_title || "No items found"}
                    </p>
                    <p class="text-base-content/70">
                      {@empty_message || "There are no items to display."}
                    </p>
                    <%= if @empty_action do %>
                      <div class="mt-4">
                        {render_slot(@empty_action)}
                      </div>
                    <% end %>
                  </div>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <%= if @pagination do %>
        <div class="bg-base-100 px-4 py-3 flex items-center justify-between border-t border-base-300 sm:px-6">
          <div class="flex-1 flex justify-between sm:hidden">
            <%= if @pagination.page_number > 1 do %>
              <button
                type="button"
                phx-click="paginate"
                phx-value-page={@pagination.page_number - 1}
                phx-target={@myself}
                class="relative inline-flex items-center px-4 py-2 border border-base-300 text-sm font-medium rounded-md text-base-content bg-base-100 hover:bg-base-200"
              >
                Previous
              </button>
            <% else %>
              <span class="relative inline-flex items-center px-4 py-2 border border-neutral-400 text-sm font-medium rounded-md text-neutral-400 bg-base-200 cursor-not-allowed">
                Previous
              </span>
            <% end %>

            <%= if @pagination.page_number < @pagination.total_pages do %>
              <button
                type="button"
                phx-click="paginate"
                phx-value-page={@pagination.page_number + 1}
                phx-target={@myself}
                class="ml-3 relative inline-flex items-center px-4 py-2 border border-base-300 text-sm font-medium rounded-md text-base-content bg-base-100 hover:bg-base-200"
              >
                Next
              </button>
            <% else %>
              <span class="ml-3 relative inline-flex items-center px-4 py-2 border border-neutral-400 text-sm font-medium rounded-md text-neutral-400 bg-base-200 cursor-not-allowed">
                Next
              </span>
            <% end %>
          </div>

          <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
              <p class="text-sm text-base-content/70">
                Showing
                <span class="font-medium">
                  {(@pagination.page_number - 1) * @pagination.page_size + 1}
                </span>
                to
                <span class="font-medium">
                  {min(@pagination.page_number * @pagination.page_size, @pagination.total_entries)}
                </span>
                of <span class="font-medium">{@pagination.total_entries}</span>
                results
              </p>
            </div>

            <div>
              <nav
                class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px"
                aria-label="Pagination"
              >
                <%= if @pagination.page_number > 1 do %>
                  <button
                    type="button"
                    phx-click="paginate"
                    phx-value-page={@pagination.page_number - 1}
                    phx-target={@myself}
                    class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-base-300 bg-base-100 text-sm font-medium text-base-content/70 hover:bg-base-200"
                  >
                    <span class="sr-only">Previous</span>
                    <i class="fas fa-chevron-left"></i>
                  </button>
                <% else %>
                  <span class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-neutral-400 bg-base-200 text-sm font-medium text-neutral-400 cursor-not-allowed">
                    <span class="sr-only">Previous</span>
                    <i class="fas fa-chevron-left"></i>
                  </span>
                <% end %>

                <%= for page <- get_page_range(@pagination) do %>
                  <%= if page == @pagination.page_number do %>
                    <span class="relative inline-flex items-center px-4 py-2 border border-secondary bg-secondary text-sm font-medium text-secondary-content">
                      {page}
                    </span>
                  <% else %>
                    <button
                      type="button"
                      phx-click="paginate"
                      phx-value-page={page}
                      phx-target={@myself}
                      class="relative inline-flex items-center px-4 py-2 border border-base-300 bg-base-100 text-sm font-medium text-base-content hover:bg-base-200"
                    >
                      {page}
                    </button>
                  <% end %>
                <% end %>

                <%= if @pagination.page_number < @pagination.total_pages do %>
                  <button
                    type="button"
                    phx-click="paginate"
                    phx-value-page={@pagination.page_number + 1}
                    phx-target={@myself}
                    class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-base-300 bg-base-100 text-sm font-medium text-base-content/70 hover:bg-base-200"
                  >
                    <span class="sr-only">Next</span>
                    <i class="fas fa-chevron-right"></i>
                  </button>
                <% else %>
                  <span class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-neutral-400 bg-base-200 text-sm font-medium text-neutral-400 cursor-not-allowed">
                    <span class="sr-only">Next</span>
                    <i class="fas fa-chevron-right"></i>
                  </span>
                <% end %>
              </nav>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, sort_config: %{field: nil, direction: :asc})}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:sortable, fn -> false end)
      |> assign_new(:sort_config, fn -> %{field: nil, direction: :asc} end)
      |> assign_new(:row_click_enabled, fn -> false end)
      |> assign_new(:empty_title, fn -> nil end)
      |> assign_new(:empty_message, fn -> nil end)
      |> assign_new(:empty_icon, fn -> nil end)
      |> assign_new(:empty_action, fn -> [] end)
      |> assign_new(:pagination, fn -> nil end)
      |> assign_new(:row_func, fn -> nil end)

    {:ok, socket}
  end

  @impl true
  def handle_event("sort", %{"field" => field}, socket) do
    current_sort = socket.assigns.sort_config

    new_direction =
      if current_sort.field == field and current_sort.direction == :asc do
        :desc
      else
        :asc
      end

    sort_config = %{field: field, direction: new_direction}

    send(self(), {:table_sort_changed, sort_config})
    {:noreply, assign(socket, sort_config: sort_config)}
  end

  def handle_event("paginate", %{"page" => page}, socket) do
    page_number = String.to_integer(page)
    send(self(), {:table_page_changed, page_number})
    {:noreply, socket}
  end

  def handle_event("row_clicked", %{"row-index" => row_index}, socket) do
    index = String.to_integer(row_index)
    row = Enum.at(socket.assigns.rows, index)
    send(self(), {:table_row_clicked, row, index})
    {:noreply, socket}
  end

  defp get_row_cells(row, headers, nil) do
    # Default behavior: assume row is a list/tuple matching header count
    case row do
      row when is_list(row) -> row
      row when is_tuple(row) -> Tuple.to_list(row)
      _ -> List.duplicate("", length(headers))
    end
  end

  defp get_row_cells(row, _headers, row_func) when is_function(row_func) do
    row_func.(row)
  end

  defp get_page_range(pagination) do
    start_page = max(1, pagination.page_number - 2)
    end_page = min(pagination.total_pages, pagination.page_number + 2)
    start_page..end_page
  end

  defp aria_sort(%{field: field, direction: :asc}, field), do: "ascending"
  defp aria_sort(%{field: field, direction: :desc}, field), do: "descending"
  defp aria_sort(_sort_config, _field), do: "none"
end
