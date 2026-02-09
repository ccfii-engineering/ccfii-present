defmodule ClaperWeb.EventLive.ManageSlidePreviewComponent do
  use ClaperWeb, :live_component

  alias Claper.Presentations

  def render(assigns) do
    slide_urls = Presentations.get_slide_urls(assigns.presentation_file)
    current_slide_url = Enum.at(slide_urls, assigns.current_position)
    assigns = assign(assigns, :current_slide_url, current_slide_url)

    ~H"""
    <div class="flex flex-col h-full">
      <div class="px-4 py-3 border-b border-gray-200 flex items-center justify-between">
        <div class="flex items-center gap-x-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-500"
          >
            <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
            <path
              fill-rule="evenodd"
              d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z"
              clip-rule="evenodd"
            />
          </svg>
          <span class="font-semibold text-gray-700">{gettext("Preview")}</span>
        </div>
        <div class="flex items-center gap-x-2 text-sm text-gray-500">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-4 h-4"
          >
            <path
              fill-rule="evenodd"
              d="M1 2.75A.75.75 0 0 1 1.75 2h16.5a.75.75 0 0 1 0 1.5H18v8.75A2.75 2.75 0 0 1 15.25 15h-1.072l.798 3.06a.75.75 0 0 1-1.452.38L13.41 18H6.59l-.114.44a.75.75 0 0 1-1.452-.38L5.823 15H4.75A2.75 2.75 0 0 1 2 12.25V3.5h-.25A.75.75 0 0 1 1 2.75Z"
              clip-rule="evenodd"
            />
          </svg>
          <span>{@current_position + 1}/{@total_slides}</span>
        </div>
      </div>
      <div class="flex-1 flex items-center justify-center p-2 bg-gray-100 relative overflow-hidden">
        <button
          :if={@current_position > 0}
          phx-click="current-page"
          phx-value-page={@current_position - 1}
          class="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-white shadow-lg flex items-center justify-center hover:bg-gray-50 transition-colors z-10"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-600"
          >
            <path
              fill-rule="evenodd"
              d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z"
              clip-rule="evenodd"
            />
          </svg>
        </button>

        <div
          :if={@current_position <= 0}
          class="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center opacity-50 cursor-not-allowed"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-400"
          >
            <path
              fill-rule="evenodd"
              d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z"
              clip-rule="evenodd"
            />
          </svg>
        </div>

        <div class="h-full aspect-video bg-white rounded-lg shadow-lg overflow-hidden">
          <img
            :if={@current_slide_url}
            src={@current_slide_url}
            class="w-full h-full object-contain"
            alt={"Slide #{@current_position + 1}"}
          />
          <div
            :if={!@current_slide_url}
            class="w-full h-full flex items-center justify-center text-gray-400"
          >
            <span>{gettext("No slide available")}</span>
          </div>
        </div>

        <button
          :if={@current_position < @total_slides - 1}
          phx-click="current-page"
          phx-value-page={@current_position + 1}
          class="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-white shadow-lg flex items-center justify-center hover:bg-gray-50 transition-colors z-10"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-600"
          >
            <path
              fill-rule="evenodd"
              d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z"
              clip-rule="evenodd"
            />
          </svg>
        </button>

        <div
          :if={@current_position >= @total_slides - 1}
          class="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center opacity-50 cursor-not-allowed"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-400"
          >
            <path
              fill-rule="evenodd"
              d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
      </div>
    </div>
    """
  end
end
