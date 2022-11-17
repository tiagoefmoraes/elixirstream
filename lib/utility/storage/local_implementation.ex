defmodule Utility.GenDiff.Storage.LocalImplementation do
  @behaviour Utility.GenDiff.Storage

  def list(project, term) do
    [dir(), project, term]
    |> Path.join()
    |> Path.wildcard()
  end

  def delete(file) do
    File.rm(file)
  end

  def get(project, id) do
    hash = :erlang.phash2({Application.get_env(:utility, :cache_version), id})
    filename = key(project, id, hash)
    path = Path.join([dir(), project, filename])

    if File.regular?(path) do
      {:ok, File.stream!(path, [:read_ahead])}
    else
      {:error, :not_found}
    end
  end

  def put(project, id, file_path) do
    hash = :erlang.phash2({Application.get_env(:utility, :cache_version), id})
    filename = key(project, id, hash)
    destination_path = Path.join([dir(), project, filename])

    File.mkdir_p!(Path.dirname(destination_path))
    File.cp!(file_path, destination_path)
    :ok
  end

  defp key(project, id, hash) do
    "#{project}-#{id}-#{hash}.html"
  end

  defp dir() do
    Path.join(Application.get_env(:utility, :gendiff_storage_dir), "diff-html")
  end
end
