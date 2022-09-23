defmodule TransformMap.Export do
  @moduledoc """
  Functions for exporting maps to various formats.
  """

  alias Elixlsx.Workbook
  alias Elixlsx.Sheet

  @base_dir "temp/"

  @doc """
  Compress a file.

  ## Examples

      iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}]
      iex> array = TransformMap.multiple_to_array(map, "|", true, true)
      iex> {_status, full_path} = TransformMap.Export.to_csv(array, "test.csv", false, "temp/report")
      iex> {status, _full_path} = TransformMap.Export.to_gzip(full_path)
      iex> status
      :ok
  """
  def to_gzip(full_path) do
    gz_path =
      full_path <> ".gz"
    gz_file =
      File.open!(gz_path, [:write, :compressed])
    _copy =
      File.copy!(full_path, gz_file)
    status =
      File.close(gz_file)
    {status, gz_path}
  end

  @doc """
  Convert map to XLSX file.

  ## Examples

      iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}]
      iex> array = TransformMap.multiple_to_array(map, "|", true, true)
      iex> {status, _full_path} = TransformMap.Export.to_xlsx(array, "test.xlsx", true, "temp/report")
      iex> status
      :ok
  """
  def to_xlsx(data, file_name, compress \\ true, directory \\ @base_dir) do
    sheet_name =
      "data"
    sheet_data =
      %Sheet{name: sheet_name, rows: data}
    dir =
      directory
      |> base_dir()
    full_path =
      dir <> file_name
    {status, _file} =
      %Workbook{sheets: [sheet_data]}
      |> Elixlsx.write_to(full_path)
    case compress do
      true ->
        to_gzip(full_path)
      false ->
        {status, full_path}
    end
  end

  @doc """
  Convert map to JSON file.

  ## Examples

      iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}]
      iex> {status, _full_path} = TransformMap.Export.to_json(map, "test.json", true, "temp/report")
      iex> status
      :ok
  """
  def to_json(data, file_name, compress \\ true, directory \\ @base_dir) do
    dir =
      directory
      |> base_dir()
    full_path =
      dir <> file_name
    json_data =
      data
      |> JSX.encode([{:strict, [:utf8]}])
      |> elem(1)
    status =
      File.write!(full_path, json_data, [:write])
    case compress do
      true ->
        to_gzip(full_path)
      false ->
        {status, full_path}
    end
  end

  @doc """
  Convert map to CSV file.

  ## Examples

      iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}]
      iex> array = TransformMap.multiple_to_array(map, "|", true, true)
      iex> {status, _full_path} = TransformMap.Export.to_csv(array, "test.csv", true, "temp/report")
      iex> status
      :ok
  """
  def to_csv(data, file_name, compress \\ true, directory \\ @base_dir) do
    dir = base_dir(directory)
    full_path = dir <> file_name
    file = File.open!(full_path, [:write, :utf8])

    stream_data =
      data
      |> Stream.map(&(&1))
      |> CSVLixir.write

    :ok = stream_file(stream_data, file)
    status = File.close(file)

    case compress do
      true ->
        to_gzip(full_path)
      false ->
        {status, full_path}
    end
  end

  defp base_dir(base) do
    dir =
      base
      |> Path.expand()
      |> Kernel.<>("/")
    File.mkdir_p(dir)
    dir
  end

  defp stream_file(stream_data, file) do
    _stream_content =
      stream_data
      |> Stream.each(&(IO.write(file, &1)))
      |> Stream.run()
  end
end
