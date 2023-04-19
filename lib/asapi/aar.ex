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

defmodule Asapi.Aar do
  alias Asapi.Aar

  @manifest 'AndroidManifest.xml'

  @enforce_keys [:group, :name]
  defstruct [:group, :name, :revision, :classifier]

  def sdk_levels!(aar_file) do
    info = load_manifest!(aar_file)
    min = sdk_ver(Regex.run(~R/android:minSdkVersion="([0-9]+)"/, info))
    max = sdk_ver(Regex.run(~R/android:maxSdkVersion="([0-9]+)"/, info))

    case {min, max} do
      {nil, nil} -> "1+"
      {sdk, sdk} -> to_string(sdk)
      {min_sdk, nil} -> "#{min_sdk}+"
      {nil, max_sdk} -> "1-#{max_sdk}"
      {min_sdk, max_sdk} -> "#{min_sdk}-#{max_sdk}"
    end
  end

  defp load_manifest!(aar_file) do
    {:ok, aar} = :zip.zip_open(aar_file, [:memory])
    {:ok, {@manifest, manifest}} = :zip.zip_get(@manifest, aar)
    :ok = :zip.zip_close(aar)
    manifest
  end

  defp sdk_ver(nil), do: nil
  defp sdk_ver([_, level]), do: String.to_integer(level)

  defimpl String.Chars, for: Aar do
    def to_string(aar) do
      case aar do
        %Aar{group: nil} ->
          nil

        %Aar{name: nil} ->
          nil

        %Aar{revision: nil, classifier: nil} ->
          "#{aar.group}:#{aar.name}:+"

        %Aar{revision: nil} ->
          "#{aar.group}:#{aar.name}:+:#{aar.classifier}"

        %Aar{classifier: nil} ->
          "#{aar.group}:#{aar.name}:#{aar.revision}"

        _ ->
          "#{aar.group}:#{aar.name}:#{aar.revision}:#{aar.classifier}"
      end
    end
  end
end
