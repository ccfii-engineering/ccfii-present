defmodule ClaperWeb.EventLive.ManageSlideSidebarComponent do
  use ClaperWeb, :live_component

  alias Claper.Presentations

  def render(assigns) do
    thumbnail_urls =
      assigns.presentation_file
      |> Presentations.get_slide_thumbnail_urls()
      |> Enum.map(&append_cache_bust(&1, assigns.thumbnail_cache_bust))

    assigns = assign(assigns, :thumbnail_urls, thumbnail_urls)

    ~H"""
    <div class="flex flex-col h-full bg-gray-100 rounded-r-2xl px-4">
      <div class="px-4 py-3 flex items-center gap-x-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 20 18"
          fill="none"
          class="shrink-0"
        >
          <path
            d="M0.849609 0.850098H18.8496M1.84961 0.850098V10.8501C1.84961 11.3805 2.06032 11.8892 2.4354 12.2643C2.81047 12.6394 3.31918 12.8501 3.84961 12.8501H15.8496C16.38 12.8501 16.8887 12.6394 17.2638 12.2643C17.6389 11.8892 17.8496 11.3805 17.8496 10.8501V0.850098M9.84961 12.8501V16.8501M6.84961 16.8501H12.8496"
            stroke="#140553"
            stroke-width="1.7"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
          <path
            d="M5.84961 8.8501L8.84961 5.8501L10.8496 7.8501L13.8496 4.8501"
            stroke="#140553"
            stroke-width="1.7"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
        </svg>

        <span class="font-bold text-sm text-[#140553]">{gettext("Content")}</span>
      </div>
      <div class="flex-1 overflow-y-auto p-3 space-y-2">
        <button
          :for={{src, index} <- @thumbnail_urls |> Enum.with_index(0)}
          id={"slide-thumb-#{index}"}
          phx-click="current-page"
          phx-value-page={index}
          class={"group flex items-start gap-x-1.5 w-full rounded-lg p-1 transition-all hover:bg-gray-200 #{if @current_position == index, do: "bg-primary-50"}"}
        >
          <span class={"flex-shrink-0 w-5 text-base font-semibold #{if @current_position == index, do: "text-primary-600", else: "text-gray-500"}"}>
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

  defp append_cache_bust(url, nil), do: url
  defp append_cache_bust(url, cache_bust), do: "#{url}?v=#{cache_bust}"
end
