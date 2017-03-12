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

defmodule Ext.Gradle do
  import Ext

  def of?(artifact) do
    version levels manifest artifact
  end

  defp manifest(artifact) do
    args = ["-Partifact=" <> artifact, "-bbin/manifest.gradle", "-q"]
    {manifest, 0} = System.cmd "gradle", args, stderr_to_stdout: true
    manifest
  end

  defp levels(manifest) do
    min_sdk = version Regex.run ~R/android:minSdkVersion="([0-9]+)"/, manifest
    max_sdk = version Regex.run ~R/android:maxSdkVersion="([0-9]+)"/, manifest
    {min_sdk, max_sdk}
  end
end
