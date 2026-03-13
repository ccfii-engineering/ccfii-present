defmodule ClaperWeb.EventLive.ManageablePostComponent do
  use ClaperWeb, :live_component

  @avatars ~w(🦊 🐙 🦉 🐸 🐼 🦋 🐬 🦈 🐢 🦎 🐝 🦩 🐧 🦦 🐨 🦁 🐯 🐻 🐰 🐮
    🐷 🐵 🦄 🐺 🦇 🐳 🐠 🦑 🦞 🦀 🐡 🐞 🦗 🕷 🦂 🐍 🦕 🦖 🦚 🦜
    🦢 🦩 🐓 🦃 🦆 🦅 🦔 🐿 🦫 🦨 🦡 🦝 🦥 🦘 🦙 🐫 🐘 🦏 🦛 🐊
    🐅 🐆 🦓 🐃 🐂 🐄 🐎 🐖 🐑 🐐 🦌 🐕 🐈 🦮 🐁 🐀 🦔 🐲 🌵 🍄)

  def render(assigns) do
    assigns =
      assigns
      |> assign_new(:readonly, fn -> false end)
      |> assign(:avatar_color, avatar_color(assigns.post))
      |> assign(:avatar_emoji, avatar_emoji(assigns.post))

    ~H"""
    <div id={"#{@id}"} class="flex items-end gap-2 group">
      <!-- Left: time + avatar -->
      <div class="flex flex-col items-center gap-2 shrink-0">
        <span class="text-xs text-gray-400 leading-4">
          {Calendar.strftime(@post.inserted_at, "%H:%M")}
        </span>
        <div class="avatar avatar-placeholder">
          <div class="text-white w-10 rounded-full" style={"background-color: #{@avatar_color}"}>
            <span class="text-base">{@avatar_emoji}</span>
          </div>
        </div>
      </div>

      <!-- Right: header + bubble -->
      <div class="flex-1 min-w-0 flex flex-col">
        <!-- Header: name + actions -->
        <div class="flex items-center gap-1 min-h-6 mb-1 ml-4">
          <p :if={@post.name} class="font-bold text-xs text-gray-700 truncate">
            {@post.name}
          </p>

          <!-- Actions (visible on hover) -->
          <div
            :if={!@readonly}
            class="ml-auto flex items-center divide-x divide-gray-200 border border-gray-200 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity shrink-0"
          >
            <div class="tooltip tooltip-bottom" data-tip={if @post.pinned, do: gettext("Unpin"), else: gettext("Pin")}>
              <button
                class="flex items-center justify-center w-8 h-6"
                phx-click="pin"
                phx-value-id={@post.uuid}
                phx-value-event_id={@event.uuid}
              >
                <%= if @post.pinned do %>
                  <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 13 13" fill="none">
                    <path
                      d="M0.5 12.5006L3.58667 9.41327M3.59 9.40994L1.73667 7.5566C1.10067 6.92127 1.74067 5.55927 2.61 5.5046C3.39533 5.4546 5.21333 5.73927 5.818 5.1346L7.478 3.4746C7.88933 3.0626 7.628 2.14127 7.60133 1.63327C7.56267 0.955937 8.64 0.11927 9.21133 0.690603L12.3093 3.78927C12.8827 4.36127 12.0427 5.43527 11.3673 5.39927C10.8593 5.3726 9.93733 5.11127 9.52533 5.5226L7.86533 7.1826C7.26133 7.78727 7.54533 9.6046 7.496 10.3899C7.44133 11.2599 6.07933 11.8999 5.44267 11.2633L3.59 9.40994Z"
                      fill="#140553"
                      stroke="#140553"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                <% else %>
                  <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 13 13" fill="none">
                    <path
                      d="M0.5 12.5006L3.58667 9.41327M3.59 9.40994L1.73667 7.5566C1.10067 6.92127 1.74067 5.55927 2.61 5.5046C3.39533 5.4546 5.21333 5.73927 5.818 5.1346L7.478 3.4746C7.88933 3.0626 7.628 2.14127 7.60133 1.63327C7.56267 0.955937 8.64 0.11927 9.21133 0.690603L12.3093 3.78927C12.8827 4.36127 12.0427 5.43527 11.3673 5.39927C10.8593 5.3726 9.93733 5.11127 9.52533 5.5226L7.86533 7.1826C7.26133 7.78727 7.54533 9.6046 7.496 10.3899C7.44133 11.2599 6.07933 11.8999 5.44267 11.2633L3.59 9.40994Z"
                      stroke="#140553"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                <% end %>
              </button>
            </div>
            <%= if @post.attendee_identifier do %>
              <div class="tooltip tooltip-bottom" data-tip={gettext("Ban")}>
                <button
                  class="flex items-center justify-center w-8 h-6"
                  phx-click="ban"
                  phx-value-attendee_identifier={@post.attendee_identifier}
                  data-confirm={gettext("Blocking this user will delete all his messages and he will not be able to join again, confirm ?")}
                >
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14" fill="none">
                    <path
                      d="M6.611 0C5.30347 0 4.0253 0.387729 2.93813 1.11415C1.85095 1.84058 1.00361 2.87308 0.503235 4.08108C0.00286441 5.28908 -0.128055 6.61833 0.127031 7.90074C0.382118 9.18315 1.01175 10.3611 1.93632 11.2857C2.86088 12.2102 4.03885 12.8399 5.32126 13.095C6.60367 13.3501 7.93292 13.2191 9.14092 12.7188C10.3489 12.2184 11.3814 11.371 12.1078 10.2839C12.8343 9.1967 13.222 7.91853 13.222 6.611C13.222 4.85765 12.5255 3.17612 11.2857 1.93632C10.0459 0.696514 8.36435 0 6.611 0ZM1.10184 6.611C1.10073 5.34054 1.54228 4.10938 2.35058 3.12921L10.0928 10.8714C9.28666 11.5326 8.30923 11.9512 7.27439 12.0783C6.23955 12.2054 5.18989 12.0358 4.2477 11.5894C3.30551 11.1429 2.50957 10.4379 1.95261 9.55652C1.39566 8.67513 1.10061 7.65362 1.10184 6.611ZM10.8714 10.0928L3.12921 2.35058C4.18518 1.48642 5.52459 1.04549 6.88739 1.11339C8.25019 1.18129 9.53914 1.75318 10.504 2.71802C11.4688 3.68286 12.0407 4.97181 12.1086 6.33461C12.1765 7.69741 11.7356 9.03682 10.8714 10.0928Z"
                      fill="#E14640"
                    />
                  </svg>
                </button>
              </div>
            <% else %>
              <div class="tooltip tooltip-bottom" data-tip={gettext("Ban")}>
                <button
                  class="flex items-center justify-center w-8 h-6"
                  phx-click="ban"
                  phx-value-user_id={@post.user_id}
                  data-confirm={gettext("Blocking this user will delete all his messages and he will not be able to join again, confirm ?")}
                >
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14" fill="none">
                    <path
                      d="M6.611 0C5.30347 0 4.0253 0.387729 2.93813 1.11415C1.85095 1.84058 1.00361 2.87308 0.503235 4.08108C0.00286441 5.28908 -0.128055 6.61833 0.127031 7.90074C0.382118 9.18315 1.01175 10.3611 1.93632 11.2857C2.86088 12.2102 4.03885 12.8399 5.32126 13.095C6.60367 13.3501 7.93292 13.2191 9.14092 12.7188C10.3489 12.2184 11.3814 11.371 12.1078 10.2839C12.8343 9.1967 13.222 7.91853 13.222 6.611C13.222 4.85765 12.5255 3.17612 11.2857 1.93632C10.0459 0.696514 8.36435 0 6.611 0ZM1.10184 6.611C1.10073 5.34054 1.54228 4.10938 2.35058 3.12921L10.0928 10.8714C9.28666 11.5326 8.30923 11.9512 7.27439 12.0783C6.23955 12.2054 5.18989 12.0358 4.2477 11.5894C3.30551 11.1429 2.50957 10.4379 1.95261 9.55652C1.39566 8.67513 1.10061 7.65362 1.10184 6.611ZM10.8714 10.0928L3.12921 2.35058C4.18518 1.48642 5.52459 1.04549 6.88739 1.11339C8.25019 1.18129 9.53914 1.75318 10.504 2.71802C11.4688 3.68286 12.0407 4.97181 12.1086 6.33461C12.1765 7.69741 11.7356 9.03682 10.8714 10.0928Z"
                      fill="#E14640"
                    />
                  </svg>
                </button>
              </div>
            <% end %>
            <div class="tooltip tooltip-bottom" data-tip={gettext("Delete")}>
              <button
                class="flex items-center justify-center w-8 h-6"
                phx-click="delete"
                phx-value-id={@post.uuid}
                phx-value-event_id={@event.uuid}
              >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path
                  d="M6.66683 3.33333H9.3335C9.3335 2.97971 9.19302 2.64057 8.94297 2.39052C8.69292 2.14048 8.35379 2 8.00016 2C7.64654 2 7.3074 2.14048 7.05735 2.39052C6.80731 2.64057 6.66683 2.97971 6.66683 3.33333ZM5.66683 3.33333C5.66683 3.02692 5.72718 2.7235 5.84444 2.44041C5.9617 2.15731 6.13358 1.90009 6.35025 1.68342C6.56692 1.46675 6.82414 1.29488 7.10723 1.17761C7.39033 1.06035 7.69375 1 8.00016 1C8.30658 1 8.61 1.06035 8.89309 1.17761C9.17618 1.29488 9.43341 1.46675 9.65008 1.68342C9.86675 1.90009 10.0386 2.15731 10.1559 2.44041C10.2731 2.7235 10.3335 3.02692 10.3335 3.33333H14.1668C14.2994 3.33333 14.4266 3.38601 14.5204 3.47978C14.6142 3.57355 14.6668 3.70073 14.6668 3.83333C14.6668 3.96594 14.6142 4.09312 14.5204 4.18689C14.4266 4.28066 14.2994 4.33333 14.1668 4.33333H13.2868L12.5068 12.4073C12.447 13.026 12.1589 13.6002 11.6986 14.0179C11.2384 14.4356 10.639 14.6669 10.0175 14.6667H5.98283C5.36141 14.6667 4.76223 14.4354 4.30213 14.0177C3.84203 13.6 3.55399 13.0259 3.49416 12.4073L2.7135 4.33333H1.8335C1.70089 4.33333 1.57371 4.28066 1.47994 4.18689C1.38617 4.09312 1.3335 3.96594 1.3335 3.83333C1.3335 3.70073 1.38617 3.57355 1.47994 3.47978C1.57371 3.38601 1.70089 3.33333 1.8335 3.33333H5.66683ZM7.00016 6.5C7.00016 6.36739 6.94748 6.24022 6.85372 6.14645C6.75995 6.05268 6.63277 6 6.50016 6C6.36755 6 6.24038 6.05268 6.14661 6.14645C6.05284 6.24022 6.00016 6.36739 6.00016 6.5V11.5C6.00016 11.6326 6.05284 11.7598 6.14661 11.8536C6.24038 11.9473 6.36755 12 6.50016 12C6.63277 12 6.75995 11.9473 6.85372 11.8536C6.94748 11.7598 7.00016 11.6326 7.00016 11.5V6.5ZM9.50016 6C9.63277 6 9.75995 6.05268 9.85372 6.14645C9.94748 6.24022 10.0002 6.36739 10.0002 6.5V11.5C10.0002 11.6326 9.94748 11.7598 9.85372 11.8536C9.75995 11.9473 9.63277 12 9.50016 12C9.36755 12 9.24038 11.9473 9.14661 11.8536C9.05284 11.7598 9.00016 11.6326 9.00016 11.5V6.5C9.00016 6.36739 9.05284 6.24022 9.14661 6.14645C9.24038 6.05268 9.36755 6 9.50016 6ZM4.4895 12.3113C4.52545 12.6824 4.69833 13.0268 4.97441 13.2774C5.25049 13.528 5.60999 13.6667 5.98283 13.6667H10.0175C10.3903 13.6667 10.7498 13.528 11.0259 13.2774C11.302 13.0268 11.4749 12.6824 11.5108 12.3113L12.2828 4.33333H3.7175L4.4895 12.3113Z"
                  fill="#7F1D1D"
                />
              </svg>
            </button>
            </div>
          </div>
        </div>

        <!-- Message bubble with tail -->
        <% is_question = ClaperWeb.Helpers.body_without_links(@post.body) =~ "?" %>
        <% bubble_bg = cond do
          @post.pinned && is_question -> "background: linear-gradient(92deg, rgba(0,0,0,0) 0%, rgba(251,191,36,0.38) 50%, rgba(134,17,237,0.38) 98%), #fff"
          @post.pinned -> "background: linear-gradient(92deg, rgba(0,0,0,0) 0%, rgba(251,191,36,0.38) 98%), #fff"
          is_question -> "background: linear-gradient(92deg, rgba(0,0,0,0) 0%, rgba(134,17,237,0.38) 98%), #fff"
          true -> "background: #fff"
        end %>
        <div class="flex items-end">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 16 16"
            fill="none"
            class="shrink-0 -mr-px"
          >
            <path d="M0 16H16V0C16 5.33333 5.33333 16 0 16Z" fill="white" />
          </svg>
          <div
            class="rounded-tl-2xl rounded-tr-2xl rounded-br-2xl flex-1 min-w-0 px-3 py-4 relative overflow-hidden"
            style={bubble_bg}
          >
            <!-- Watermark icons -->
            <div
              :if={is_question || @post.pinned}
              class="absolute right-2 top-1/2 -translate-y-1/2 flex items-center gap-3 opacity-60 pointer-events-none select-none"
            >
              <svg
                :if={@post.pinned}
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                viewBox="0 0 13 13"
                fill="none"
              >
                <path
                  d="M0.5 12.5006L3.58667 9.41327M3.59 9.40994L1.73667 7.5566C1.10067 6.92127 1.74067 5.55927 2.61 5.5046C3.39533 5.4546 5.21333 5.73927 5.818 5.1346L7.478 3.4746C7.88933 3.0626 7.628 2.14127 7.60133 1.63327C7.56267 0.955937 8.64 0.11927 9.21133 0.690603L12.3093 3.78927C12.8827 4.36127 12.0427 5.43527 11.3673 5.39927C10.8593 5.3726 9.93733 5.11127 9.52533 5.5226L7.86533 7.1826C7.26133 7.78727 7.54533 9.6046 7.496 10.3899C7.44133 11.2599 6.07933 11.8999 5.44267 11.2633L3.59 9.40994Z"
                  stroke="white"
                  stroke-width="1.2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
              <span :if={is_question} class="text-2xl text-white leading-none">?</span>
            </div>
            <p class="text-sm text-gray-700 break-words relative">
              {ClaperWeb.Helpers.format_body(@post.body)}
            </p>

            <%= if @post.like_count > 0 || @post.love_count > 0 || @post.lol_count > 0 do %>
              <div class="flex items-center gap-1 mt-2 text-gray-700">
                <div
                  :if={@post.like_count > 0}
                  class="border border-gray-200 rounded-full px-2 py-2 flex items-center gap-1"
                >
                  <span class="text-sm leading-none">👍</span>
                  <span class="font-bold text-xs">{@post.like_count}</span>
                </div>
                <div
                  :if={@post.love_count > 0}
                  class="border border-gray-200 rounded-full px-2 py-2 flex items-center gap-1"
                >
                  <span class="text-sm leading-none">❤️</span>
                  <span class="font-bold text-xs">{@post.love_count}</span>
                </div>
                <div
                  :if={@post.lol_count > 0}
                  class="border border-gray-200 rounded-full px-2 py-2 flex items-center gap-1"
                >
                  <span class="text-sm leading-none">😂</span>
                  <span class="font-bold text-xs">{@post.lol_count}</span>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp avatar_identifier(post) do
    "#{post.attendee_identifier || post.user_id || "default"}"
  end

  defp avatar_color(post) do
    hue = :erlang.phash2(avatar_identifier(post), 360)
    "hsl(#{hue}, 45%, 55%)"
  end

  defp avatar_emoji(post) do
    index = :erlang.phash2({avatar_identifier(post), :emoji}, length(@avatars))
    Enum.at(@avatars, index)
  end
end
