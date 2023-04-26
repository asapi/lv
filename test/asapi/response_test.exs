#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.ResponseTest do
  use ExUnit.Case
  use Plug.Test

  alias Asapi.Response

  doctest Response

  import Mock

  test "redirect_to returns path for non query" do
    path = "/abc"

    conn = Response.redirect_to(conn(:get, ""), path)

    assert conn.status == 307
    assert conn.resp_body == ""
    assert {"location", path} in conn.resp_headers
  end

  test "redirect_to returns path for consumed query" do
    path = "/abc"
    query = "a=b&c=d&e=f"

    conn = Response.redirect_to(conn(:get, "?#{query}"), path, ["a", "c", "e"])

    assert conn.status == 307
    assert conn.resp_body == ""
    assert {"location", path} in conn.resp_headers
  end

  test "redirect_to returns path with query" do
    path = "/abc"
    query = "a=b&c=d&e=f"

    conn = Response.redirect_to(conn(:get, "?#{query}"), path)

    assert conn.status == 307
    assert conn.resp_body == ""
    assert {"location", "#{path}?#{query}"} in conn.resp_headers
  end

  test "redirect_to returns path with non consumed query" do
    path = "/abc"
    query = "a=b&c=d&e=f"

    conn = Response.redirect_to(conn(:get, "?#{query}"), path, ["c"])

    assert conn.status == 307
    assert conn.resp_body == ""
    assert {"location", "#{path}?a=b&e=f"} in conn.resp_headers
  end

  test "redirect_to redirects url" do
    url = "https://www.example.com/path"

    conn = Response.redirect_to(conn(:get, ""), url)

    assert conn.status == 307
    assert conn.resp_body == ""
    assert {"location", url} in conn.resp_headers
  end

  test_with_mock "send_html is ok and root path", EEx,
    eval_file: fn file, bindings -> "#{file}:#{inspect(bindings[:assigns])}" end do
    conn = Response.send_html(conn(:get, ""), "lib", "api", "loading")

    template = "priv/temp/asapi.html.eex"
    assigns = [host: conn.host, path: "/", lib: "lib", api: "api", loading: "loading"]

    assert conn.status == 200
    assert conn.resp_body == "#{template}:#{inspect(assigns)}"
  end

  test_with_mock "send_html is ok and full path", EEx,
    eval_file: fn file, bindings -> "#{file}:#{inspect(bindings[:assigns])}" end do
    conn = Response.send_html(conn(:get, "/path/to/"), "lib", "api", "loading")

    template = "priv/temp/asapi.html.eex"
    assigns = [host: conn.host, path: "/path/to", lib: "lib", api: "api", loading: "loading"]

    assert conn.status == 200
    assert conn.resp_body == "#{template}:#{inspect(assigns)}"
  end

  test "send_text is ok and plain text" do
    text = "some text to send"

    conn = Response.send_text(conn(:get, "/"), text)

    assert conn.status == 200
    assert conn.resp_body == text
    assert {"content-type", "text/plain; charset=utf-8"} in conn.resp_headers
  end
end
