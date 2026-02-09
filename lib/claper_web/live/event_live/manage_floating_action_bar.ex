defmodule ClaperWeb.EventLive.ManageFloatingActionBar do
  use ClaperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="fixed bottom-6 left-1/2 -translate-x-1/2 z-40">
      <div class="flex items-center gap-x-1 bg-white rounded-full shadow-xl px-2 py-2 border border-gray-200">
        <.link
          patch={~p"/e/#{@event_code}/manage/add/poll"}
          class="flex items-center gap-x-2 px-4 py-2 rounded-full hover:bg-gray-100 transition-colors text-gray-700"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-primary-500"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M16 8v8m-4-5v5m-4-2v2m-2 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
            />
          </svg>
          <span class="font-medium text-sm">{gettext("Polls")}</span>
        </.link>

        <div class="w-px h-6 bg-gray-200"></div>

        <.link
          patch={~p"/e/#{@event_code}/manage/add/form"}
          class="flex items-center gap-x-2 px-4 py-2 rounded-full hover:bg-gray-100 transition-colors text-gray-700"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-primary-500"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
            />
          </svg>
          <span class="font-medium text-sm">{gettext("Forms")}</span>
        </.link>

        <div class="w-px h-6 bg-gray-200"></div>

        <.link
          patch={~p"/e/#{@event_code}/manage/add/embed"}
          class="flex items-center gap-x-2 px-4 py-2 rounded-full hover:bg-gray-100 transition-colors text-gray-700"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            class="w-5 h-5 text-primary-500"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M14.25 9.75L16.5 12l-2.25 2.25m-4.5 0L7.5 12l2.25-2.25M6 20.25h12A2.25 2.25 0 0020.25 18V6A2.25 2.25 0 0018 3.75H6A2.25 2.25 0 003.75 6v12A2.25 2.25 0 006 20.25z"
            />
          </svg>
          <span class="font-medium text-sm">{gettext("Web Content")}</span>
        </.link>

        <div class="w-px h-6 bg-gray-200"></div>

        <.link
          patch={~p"/e/#{@event_code}/manage/add/quiz"}
          class="flex items-center gap-x-2 px-4 py-2 rounded-full hover:bg-gray-100 transition-colors text-gray-700"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            class="w-5 h-5 text-primary-500"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 5.25h.008v.008H12v-.008Z"
            />
          </svg>
          <span class="font-medium text-sm">{gettext("Quiz")}</span>
        </.link>
      </div>
    </div>
    """
  end
end
