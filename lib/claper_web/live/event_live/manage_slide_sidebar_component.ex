defmodule ClaperWeb.EventLive.ManageSlideSidebarComponent do
  use ClaperWeb, :live_component

  alias Claper.Presentations

  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full bg-white">
      <div class="px-4 py-3 border-b border-gray-200 flex items-center gap-x-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          class="w-5 h-5 text-gray-500"
        >
          <path
            fill-rule="evenodd"
            d="M1 2.75A.75.75 0 0 1 1.75 2h16.5a.75.75 0 0 1 0 1.5H18v8.75A2.75 2.75 0 0 1 15.25 15h-1.072l.798 3.06a.75.75 0 0 1-1.452.38L13.41 18H6.59l-.114.44a.75.75 0 0 1-1.452-.38L5.823 15H4.75A2.75 2.75 0 0 1 2 12.25V3.5h-.25A.75.75 0 0 1 1 2.75Z"
            clip-rule="evenodd"
          />
        </svg>
        <span class="font-semibold text-gray-700">{gettext("Content")}</span>
      </div>
      <div class="flex-1 overflow-y-auto p-3 space-y-2">
        <button
          :for={
            {src, index} <-
              Presentations.get_slide_thumbnail_urls(@presentation_file) |> Enum.with_index(0)
          }
          id={"slide-thumb-#{index}"}
          phx-click="current-page"
          phx-value-page={index}
          class={"group flex items-start gap-x-2 w-full rounded-lg p-1 transition-all hover:bg-gray-100 #{if @current_position == index, do: "bg-primary-50"}"}
        >
          <span class={"flex-shrink-0 w-6 text-sm font-medium #{if @current_position == index, do: "text-primary-600", else: "text-gray-500"}"}>
            {index + 1}
          </span>
          <div class={"relative w-28 aspect-video rounded-md overflow-hidden border-2 transition-all #{if @current_position == index, do: "border-primary-500 shadow-md", else: "border-transparent opacity-60 group-hover:opacity-100"}"}>
            <img
              src={src}
              loading="lazy"
              decoding="async"
              class="w-full h-full object-cover"
              alt={"Slide #{index + 1}"}
            />
          </div>
        </button>
      </div>
    </div>
    """
  end
end
