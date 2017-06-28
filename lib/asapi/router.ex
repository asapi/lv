#   asapi/lv
#   Copyright (C) 2017  tynn
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

defmodule Asapi.Router do
  require Logger
  use Trot.Router
  use Trot.Template
  @template_root "html"

  @shields "https://img.shields.io/badge"
  @label "API"
  @color "blue"

  get "/:path/api.png" do
    badge path, :png
  end

  get "/:path/api.svg" do
    badge path, :svg
  end

  get "/:path/api.txt" do
    asapi_lv_of path
  end

  get "/:group/:artifact" do
    asapi_lv library(group, artifact), conn
  end

  get "/:group/:artifact/+" do
    {:redirect, "/#{group}/#{artifact}"}
  end

  get "/:group/:artifact/api.png" do
    badge library(group, artifact), :png
  end

  get "/:group/:artifact/api.svg" do
    badge library(group, artifact), :svg
  end

  get "/:group/:artifact/api.txt" do
    asapi_lv_of library group, artifact
  end

  get "/*path" do
    case Enum.reverse(path) do
      ["api.png" | path] -> badge library(Enum.reverse(path)), :png
      ["api.svg" | path] -> badge library(Enum.reverse(path)), :svg
      ["api.txt" | path] -> asapi_lv_of library Enum.reverse path
      _ -> asapi_lv library(path), conn
    end
  end

  defp library(path) do
    Enum.join(path, ":")
  end

  defp library(group, artifact) do
    group <> ":" <> artifact <> ":+"
  end

  defp asapi_lv(lib, conn) do
    path = case conn.request_path do
      "/" -> ""
      path -> path
    end
    api = asapi_lv_of lib
    loading = shield("…") <> ".svg"
    args = [host: conn.host, path: path, lib: lib, api: api, loading: loading]
    render_template "asapi.html.eex", args
  end

  defp asapi_lv_of(lib) do
    try do
      Asapi.Lv.of! Asapi.aar lib
    rescue error ->
      Logger.warn Exception.message error
      "unknown"
    end
  end

  defp shield(notice) when notice in ["…", "unknown"] do
    "#{@shields}/#{@label}-#{encode notice}-lightgrey"
  end

  defp shield(api) do
    "#{@shields}/#{@label}-#{encode api}-#{@color}"
  end

  defp encode(part) do
    URI.encode part, &URI.char_unreserved?/1
  end

  defp badge(lib, type) do
    {:redirect, shield(asapi_lv_of lib) <> "." <> to_string(type)}
  end
end
