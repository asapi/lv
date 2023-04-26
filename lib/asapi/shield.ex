#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Shield do
  @loading "…"
  @unknown "unknown"

  def shield(status, json \\ false)

  def shield(status, json) when status in [@loading, @unknown] do
    shield(status, "inactive", json)
  end

  def shield(status, json) do
    shield(status, "informational", json)
  end

  defp shield(status, color, json) do
    unless json do
      "https://img.shields.io/badge/API-#{encode(status)}-#{color}"
    else
      "{\"schemaVersion\":1,\"label\":\"API\",\"message\":\"#{status}\",\"color\":\"#{color}\"}"
    end
  end

  defp encode(part) do
    String.replace(part, "-", "--")
  end

  defmacro __using__(_) do
    quote do
      import Asapi.Shield
      @loading unquote(@loading)
      @unknown unquote(@unknown)
    end
  end
end
