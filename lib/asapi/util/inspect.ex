#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Util.Inspect do
  @behaviour Plug
  def init(opts), do: opts
  def call(%Plug.Conn{} = conn, _opts), do: IO.inspect(conn)
end
