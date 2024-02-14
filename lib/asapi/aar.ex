#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Aar do
  alias Asapi.Aar

  @manifest 'AndroidManifest.xml'

  @enforce_keys [:group, :name]
  defstruct [:group, :name, :revision, :classifier]

  def sdk_levels!(aar_file) do
    info = load_manifest!(aar_file)
    min = sdk_ver(Regex.run(~r/android:minSdkVersion="([0-9]+)"/, info))
    max = sdk_ver(Regex.run(~r/android:maxSdkVersion="([0-9]+)"/, info))

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
