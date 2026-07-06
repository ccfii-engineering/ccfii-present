defmodule ClaperWeb.EventLive.ManageAudienceResponsesComponent do
  @moduledoc false
  use Phoenix.Component
  use Gettext, backend: ClaperWeb.Gettext

  @avatars ~w(🦊 🐙 🦉 🐸 🐼 🦋 🐬 🦈 🐢 🦎 🐝 🦩 🐧 🦦 🐨 🦁 🐯 🐻 🐰 🐮
    🐷 🐵 🦄 🐺 🦇 🐳 🐠 🦑 🦞 🦀 🐡 🐞 🦗 🕷 🦂 🐍 🦕 🦖 🦚 🦜
    🦢 🦩 🐓 🦃 🦆 🦅 🦔 🐿 🦫 🦨 🦡 🦝 🦥 🦘 🦙 🐫 🐘 🦏 🦛 🐊
    🐅 🐆 🦓 🐃 🐂 🐄 🐎 🐖 🐑 🐐 🦌 🐕 🐈 🦮 🐁 🐀 🦔 🐲 🌵 🍄)

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 border border-gray-200 rounded-2xl p-2 flex-1 overflow-hidden bg-gray-100">
      <div class="flex items-center gap-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 20 20"
          fill="none"
          class="shrink-0"
        >
          <path
            fill-rule="evenodd"
            d="M10 2c-2.236 0-4.43.18-6.57.524C1.993 2.755 1 4.014 1 5.426v5.148c0 1.413.993 2.67 2.43 2.902.848.137 1.705.248 2.57.331v3.443a.75.75 0 0 0 1.28.53l3.58-3.579a.78.78 0 0 1 .527-.224 41.202 41.202 0 0 0 5.183-.5c1.437-.232 2.43-1.49 2.43-2.903V5.426c0-1.413-.993-2.67-2.43-2.902A41.289 41.289 0 0 0 10 2Zm0 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2ZM8 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0Zm5 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z"
            clip-rule="evenodd"
            fill="#140553"
          />
        </svg>
        <span class="font-bold text-sm text-[#140553]">{gettext("Audience Responses")}</span>
      </div>
      
    <!-- Tabs -->
      <ul id="menu" phx-update="replace" class="flex items-center gap-x-1 overflow-x-auto">
        <li>
          <button
            phx-click="list-tab"
            phx-value-tab="posts"
            class={"px-3 py-1.5 rounded-full text-sm font-medium transition-colors #{if @list_tab == :posts, do: "bg-secondary-500 text-white", else: "text-gray-600 hover:bg-gray-100"}"}
          >
            {gettext("Messages")} ({@post_count})
          </button>
        </li>
        <li>
          <button
            phx-click="list-tab"
            phx-value-tab="questions"
            class={"px-3 py-1.5 rounded-full text-sm font-medium transition-colors #{if @list_tab == :questions, do: "bg-secondary-500 text-white", else: "text-gray-600 hover:bg-gray-100"}"}
          >
            {gettext("Questions")} ({@question_count})
          </button>
        </li>
        <li>
          <button
            phx-click="list-tab"
            phx-value-tab="pinned_posts"
            class={"px-3 py-1.5 rounded-full text-sm font-medium transition-colors #{if @list_tab == :pinned_posts, do: "bg-secondary-500 text-white", else: "text-gray-600 hover:bg-gray-100"}"}
          >
            {gettext("Pinned")} ({@pinned_post_count})
          </button>
        </li>
        <li>
          <button
            phx-click="list-tab"
            phx-value-tab="forms"
            class={"px-3 py-1.5 rounded-full text-sm font-medium transition-colors #{if @list_tab == :forms, do: "bg-secondary-500 text-white", else: "text-gray-600 hover:bg-gray-100"}"}
          >
            {gettext("Forms")} ({@form_submit_count})
          </button>
        </li>
      </ul>
      
    <!-- Tab Content -->
      <div class="flex-1 overflow-y-auto overflow-x-hidden">
        <%= if @list_tab == :posts do %>
          <div
            :if={@post_count == 0}
            class="h-full flex flex-col items-center justify-center text-gray-400 py-8"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-12 w-12 mb-3"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="1.5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z"
              />
            </svg>
            <p class="text-sm">{gettext("Messages from attendees will appear here.")}</p>
          </div>
          <div :if={@post_count > 0} id="post-list" class="p-2 space-y-3" phx-update="stream">
            <.live_component
              :for={{id, post} <- @streams.posts}
              module={ClaperWeb.EventLive.ManageablePostComponent}
              id={id}
              event={@event}
              post={post}
            />
          </div>
        <% end %>

        <%= if @list_tab == :questions do %>
          <div
            :if={@question_count == 0}
            class="h-full flex flex-col items-center justify-center text-gray-400 py-8"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-12 h-12 mb-3"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 5.25h.008v.008H12v-.008Z"
              />
            </svg>
            <p class="text-sm">{gettext("Questions will appear here.")}</p>
          </div>
          <div :if={@question_count > 0} class="flex flex-col h-full">
            <div class="px-2 py-2 flex items-center gap-x-2">
              <span class="text-xs text-gray-500">{gettext("Sort by:")}</span>
              <div class="tooltip tooltip-bottom" data-tip={gettext("Show newest questions first")}>
                <button
                  class="px-3 py-1 text-xs rounded-md bg-gray-100 text-gray-700 hover:bg-gray-200 flex items-center gap-x-1"
                  phx-click="sort-questions"
                  phx-value-sort="date"
                >
                  {gettext("Most recent")}
                </button>
              </div>
              <div
                class="tooltip tooltip-bottom"
                data-tip={gettext("Show most voted questions first")}
              >
                <button
                  class="px-3 py-1 text-xs rounded-md bg-gray-100 text-gray-700 hover:bg-gray-200 flex items-center gap-x-1"
                  phx-click="sort-questions"
                  phx-value-sort="likes"
                >
                  {gettext("Most popular")}
                </button>
              </div>
            </div>
            <div
              id="question-list"
              class="flex-1 overflow-y-auto overflow-x-hidden p-2 space-y-3"
              phx-update="stream"
            >
              <.live_component
                :for={{id, post} <- @streams.questions}
                module={ClaperWeb.EventLive.ManageablePostComponent}
                id={id}
                event={@event}
                post={post}
              />
            </div>
          </div>
        <% end %>

        <%= if @list_tab == :pinned_posts do %>
          <div
            :if={@pinned_post_count == 0}
            class="h-full flex flex-col items-center justify-center text-gray-400 py-8"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-12 w-12 mb-3"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M15 4.5l-4 4l-4 1.5l-1.5 1.5l7 7l1.5 -1.5l1.5 -4l4 -4" /><path d="M9 15l-4.5 4.5" /><path d="M14.5 4l5.5 5.5" />
            </svg>
            <p class="text-sm">{gettext("Pinned messages will appear here.")}</p>
          </div>
          <div
            :if={@pinned_post_count > 0}
            id="pinned-post-list"
            class="p-2 space-y-3"
            phx-update="stream"
          >
            <.live_component
              :for={{id, post} <- @streams.pinned_posts}
              module={ClaperWeb.EventLive.ManageablePostComponent}
              id={id}
              event={@event}
              post={post}
            />
          </div>
        <% end %>

        <%= if @list_tab == :forms do %>
          <div
            :if={@form_submit_count == 0}
            class="h-full flex flex-col items-center justify-center text-gray-400 py-8"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-12 w-12 mb-3"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M12 3a3 3 0 0 0 -3 3v12a3 3 0 0 0 3 3"></path>
              <path d="M6 3a3 3 0 0 1 3 3v12a3 3 0 0 1 -3 3"></path>
              <path d="M13 7h7a1 1 0 0 1 1 1v8a1 1 0 0 1 -1 1h-7"></path>
              <path d="M5 7h-1a1 1 0 0 0 -1 1v8a1 1 0 0 0 1 1h1"></path>
              <path d="M17 12h.01"></path>
              <path d="M13 12h.01"></path>
            </svg>
            <p class="text-sm">{gettext("Form submissions will appear here.")}</p>
          </div>
          <div
            id="form-list"
            class="p-2 space-y-3"
            phx-update="stream"
            data-forms-nb={@form_submit_count}
            phx-hook="ScrollIntoDiv"
          >
            <div :for={{id, submission} <- @streams.form_submits} id={id}>
              <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                <div class="flex items-center justify-end mb-2">
                  <button
                    phx-click="delete-form-submit"
                    phx-value-id={submission.id}
                    data-confirm={gettext("This cannot be undone, confirm ?")}
                    class="text-xs text-red-500 hover:text-red-700"
                  >
                    {gettext("Delete")}
                  </button>
                </div>
                <div class="flex items-start gap-x-3">
                  <div class="avatar avatar-placeholder shrink-0">
                    <div
                      class="text-white w-8 rounded-full"
                      style={"background-color: #{avatar_color(submission)}"}
                    >
                      <span class="text-sm">{avatar_emoji(submission)}</span>
                    </div>
                  </div>
                  <div class="flex-1 text-sm text-gray-600">
                    <%= for res <- submission.response do %>
                      <p>
                        <span class="font-medium">{elem(res, 0)}:</span>
                        {elem(res, 1)}
                      </p>
                    <% end %>
                  </div>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp avatar_identifier(record) do
    "#{record.attendee_identifier || record.user_id || "default"}"
  end

  defp avatar_color(record) do
    hue = :erlang.phash2(avatar_identifier(record), 360)
    "hsl(#{hue}, 45%, 55%)"
  end

  defp avatar_emoji(record) do
    index = :erlang.phash2({avatar_identifier(record), :emoji}, length(@avatars))
    Enum.at(@avatars, index)
  end
end
