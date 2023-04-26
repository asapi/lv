#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Ext.Repo do
  use Tesla

  alias Asapi.Ext.Version
  alias Asapi.Aar

  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.Retry, max_retries: 3

  @repos [
    "https://maven.google.com",
    "https://repo1.maven.org/maven2",
    "https://jitpack.io"
  ]

  def resolve!(%Aar{} = aar) do
    pattern =
      case aar.revision do
        nil -> ""
        "" -> ""
        rev -> String.slice(rev, 0..-2)
      end

    @repos
    |> Enum.flat_map(&versions(aar, &1))
    |> Enum.filter(&Version.matching?(pattern, &1))
    |> Enum.sort(&Version.<=/2)
    |> List.last()
    |> Map.get(:s)
  end

  defp module(repo, %Aar{} = aar) do
    "#{repo}/#{String.replace(aar.group, ".", "/")}/#{aar.name}"
  end

  defp metadata(module) do
    "#{module}/maven-metadata.xml"
  end

  defp aar_file(module, %Aar{} = aar) do
    aar_file(module, aar.revision, aar)
  end

  defp aar_file(module, revision, %Aar{classifier: nil} = aar) do
    "#{module}/#{revision}/#{aar.name}-#{revision}.aar"
  end

  defp aar_file(module, revision, %Aar{} = aar) do
    "#{module}/#{revision}/#{aar.name}-#{revision}-#{aar.classifier}.aar"
  end

  defp versions(%Aar{} = aar, repo) do
    module(repo, aar)
    |> metadata
    |> get!
    |> versions
  end

  defp versions(response) do
    if response.status in 200..299 do
      ~R{<version>([^<]+)</version>}
      |> Regex.scan(response.body)
      |> Enum.map(&version/1)
      |> Enum.reject(&is_nil/1)
    else
      []
    end
  end

  defp version(lib) do
    try do
      lib
      |> List.last()
      |> String.trim()
      |> Version.parse!()
    rescue
      _ ->
        nil
    end
  end

  def resolve?(%Aar{} = aar) do
    aar.revision
    |> case do
      nil -> true
      "" -> true
      rev -> String.ends_with?(rev, "+")
    end
  end

  def load!(%Aar{} = aar) do
    @repos
    |> Enum.reduce_while(nil, &load_aar_file!(&1, aar, &2))
    |> Aar.sdk_levels!()
  end

  defp load_aar_file!(repo, %Aar{} = aar, _) do
    module(repo, aar)
    |> aar_file(aar)
    |> get!
    |> load_aar_file
  end

  defp load_aar_file(response) do
    if response.status in 200..299 do
      {:halt, response.body}
    else
      {:cont, nil}
    end
  end
end
