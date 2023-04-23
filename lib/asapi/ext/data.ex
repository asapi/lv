#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Ext.Data do
  alias Asapi.Aar
  alias Asapi.Ext.Repo

  def get!(%Aar{} = aar) do
    aar = get_rev!(aar)
    Cachex.fetch!(:lvc, aar, &Repo.load!/1)
  end

  defp get_rev!(%Aar{} = aar) do
    if Repo.resolve?(aar) do
      rev = Cachex.fetch!(:lvc, aar, &Repo.resolve!/1)
      %{aar | revision: rev}
    else
      aar
    end
  end

  def clear!(%Aar{} = aar) do
    aar = clear_rev!(aar)
    Cachex.del(:lvc, aar)
    nil
  end

  def clear_rev!(%Aar{} = aar) do
    if Repo.resolve?(aar) do
      rev = Cachex.get!(:lvc, aar)
      Cachex.del(:lvc, aar)
      %{aar | revision: rev}
    else
      aar
    end
  end
end
