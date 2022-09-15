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

defmodule Asapi.Ext.Data do
  alias Asapi.Aar
  alias Asapi.Ext.Repo

  def get!(%Aar{} = aar) do
    aar = get_rev! aar
    Cachex.fetch! :lvc, aar, &Repo.load!/1
  end

  defp get_rev!(%Aar{} = aar) do
    if Repo.resolve? aar do
      rev = Cachex.fetch! :lvc, aar, &Repo.resolve!/1
      %{aar | revision: rev}
    else
      aar
    end  
  end

  def clear!(%Aar{} = aar) do
    aar = clear_rev! aar  
    Cachex.del :lvc, aar
    nil
  end

  def clear_rev!(%Aar{} = aar) do
    if Repo.resolve? aar do
      rev = Cachex.get! :lvc, aar
      Cachex.del :lvc, aar
      %{aar | revision: rev}
    else
      aar
    end    
  end
end
