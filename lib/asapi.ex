#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi do
  @loading "…"
  @unknown "unknown"

  def shield(status) when status in [@loading, @unknown] do
    shield(status, "inactive")
  end

  def shield(status) do
    shield(status, "informational")
  end

  defp shield(status, color) do
    "https://img.shields.io/badge/API-#{encode(status)}-#{color}"
  end

  defp encode(part) do
    String.replace(part, "-", "--")
  end

  defmacro __using__(_) do
    quote do
      import Asapi
      @loading unquote(@loading)
      @unknown unquote(@unknown)
    end
  end
end
