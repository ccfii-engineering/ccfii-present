defmodule ClaperWeb.Accessibility.CCFIIContrastTest do
  use ExUnit.Case, async: true

  @pairs [
    {"white on maroon", "#FFFFFF", "#810E0E", 7.0},
    {"warm black on gold", "#120A0A", "#FAA739", 7.0},
    {"off-white on warm black", "#F7EDED", "#120A0A", 7.0},
    {"muted copy on dark brown", "#B99B9B", "#1E1414", 7.0},
    {"white on info", "#FFFFFF", "#3567FF", 4.5},
    {"white on success", "#FFFFFF", "#147A4C", 4.5},
    {"white on error", "#FFFFFF", "#C12B34", 4.5},
    {"gold focus on warm black", "#FAA739", "#120A0A", 3.0},
    {"muted boundary on dark brown", "#B99B9B", "#1E1414", 3.0},
    {"light error action on dark brown", "#F0A4AA", "#1E1414", 4.5},
    {"light success action on dark brown", "#9DDCBC", "#1E1414", 4.5}
  ]

  @semantic_tokens [
    {"color-primary", "#810E0E"},
    {"color-primary-content", "#FFFFFF"},
    {"color-secondary", "#FAA739"},
    {"color-secondary-content", "#120A0A"},
    {"color-base-100", "#1E1414"},
    {"color-base-200", "#120A0A"},
    {"color-base-content", "#F7EDED"},
    {"color-info", "#3567FF"},
    {"color-info-content", "#FFFFFF"},
    {"color-success", "#147A4C"},
    {"color-success-content", "#FFFFFF"},
    {"color-error", "#C12B34"},
    {"color-error-content", "#FFFFFF"},
    {"color-neutral-400", "#B99B9B"},
    {"color-neutral-100", "#F7EDED"},
    {"color-neutral-900", "#1E1414"}
  ]

  test "approved foreground and background pairs meet their WCAG thresholds" do
    for {name, foreground, background, threshold} <- @pairs do
      ratio = contrast_ratio(foreground, background)

      assert ratio >= threshold,
             "#{name} contrast was #{Float.round(ratio, 2)}:1; expected at least #{threshold}:1"
    end
  end

  test "theme config maps semantic tokens to approved literals" do
    theme_config = Path.expand("../../../assets/css/theme-config.css", __DIR__) |> File.read!()

    for {token, value} <- @semantic_tokens do
      pattern = Regex.compile!("--#{Regex.escape(token)}:\\s*#{Regex.escape(value)};")
      assert Regex.match?(pattern, theme_config), "missing #{token}: #{value} mapping"
    end
  end

  test "text-bearing gradient button API uses one contrast-safe background" do
    app_css = Path.expand("../../../assets/css/app.css", __DIR__) |> File.read!()

    [button_rules] =
      Regex.run(~r/@utility btn-gradient \{(.*?)\n\}/s, app_css, capture: :all_but_first)

    assert button_rules =~ "background: #810E0E;"
    assert button_rules =~ "color: #FFFFFF;"
    refute button_rules =~ "linear-gradient"
  end

  @spec contrast_ratio(String.t(), String.t()) :: float()
  defp contrast_ratio(foreground, background) do
    foreground_luminance = relative_luminance(foreground)
    background_luminance = relative_luminance(background)

    lighter = max(foreground_luminance, background_luminance)
    darker = min(foreground_luminance, background_luminance)

    (lighter + 0.05) / (darker + 0.05)
  end

  defp relative_luminance(hex) do
    [red, green, blue] =
      hex
      |> String.trim_leading("#")
      |> String.graphemes()
      |> Enum.chunk_every(2)
      |> Enum.map(fn channel -> String.to_integer(Enum.join(channel), 16) / 255 end)
      |> Enum.map(&linearize/1)

    0.2126 * red + 0.7152 * green + 0.0722 * blue
  end

  defp linearize(channel) when channel <= 0.03928, do: channel / 12.92
  defp linearize(channel), do: :math.pow((channel + 0.055) / 1.055, 2.4)
end
