defmodule TransformMap do
  @moduledoc """
  Documentation for TransformMap.
  """

  defp convert_decimal(value) do
    case Decimal.decimal?(value) do
      true ->
        value
        |> Decimal.to_float()
      false ->
        value
    end
  end

  defp list_value(value) do
    case is_list(value) do
      true ->
        value
        |> List.flatten()
      false ->
        [value]
    end
  end

  defp join_value(value, delimiter) do
    case is_list(value) do
      true ->
        temp =
          value
          |> Enum.join(delimiter)
        [temp]
      false ->
        [value]
    end
  end

  defp other_keys(map, temp_map, value, delimiter) do
    keys =
      temp_map
      |> get_keys()
    _list =
      keys
      |> Enum.map(fn x ->
        new_value =
          [value, x]
          |> List.flatten()
        single_keys(map, new_value, delimiter)
      end)
  end

  defp single_keys(map, value, delimiter) do
    {status, temp_map} =
      case is_map(map) do
        true ->
          list =
            list_value(value)
          new_value =
            map
            |> get_in(list)
          {:ok, new_value}
        false ->
          {:error, nil}
      end
    _temp_list =
      case status do
        :error ->
          value
        :ok ->
          case Decimal.decimal?(temp_map) do
            true ->
              join_value(value, delimiter)
            false ->
              case is_map(temp_map) do
                true ->
                  other_keys(map, temp_map, value, delimiter)
                false ->
                  join_value(value, delimiter)
              end
          end
      end
  end

  defp convert_nil(item, convert_nil) do
    case is_nil(item) do
      true ->
        case convert_nil do
          true ->
            ""
          false ->
            item
        end
      false ->
        item
    end
  end

  defp to_array_parallel(header, data, convert_nil) do
    data =
      data
      |> ParallelStream.map(fn x ->
        _new_line =
          header
          |> Enum.map(fn y ->
            value =
              x
              |> Map.get(y)
            final_value =
              convert_nil(value, convert_nil)
            [final_value]
          end)
          |> Enum.into([])
          |> List.flatten()
      end)
      |> Enum.into([])
    _final =
      [header]
      |> Enum.concat(data)
  end

  defp to_array_normal(header, data, convert_nil) do
    data
    |> Enum.reduce([], fn x, acc ->
      acc =
        case acc == [] do
          true ->
            [header]
          false ->
            acc
        end
      new_line =
        header
        |> Enum.reduce([], fn y, line_acc ->
          value =
            x
            |> Map.get(y)
          final_value =
            convert_nil(value, convert_nil)
          _line_acc =
            line_acc ++ [final_value]
        end)
      _acc =
        acc
        |> Enum.concat([new_line])
    end)
  end

  defp to_array(header, data, convert_nil, parallel) do
    case parallel do
      true ->
        to_array_parallel(header, data, convert_nil)
      false ->
        to_array_normal(header, data, convert_nil)
    end
  end

  @doc """
  Convert map to 2 dimensional array.

  ## Examples

    iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}]
    ...>
    iex> _array = TransformMap.multiple_to_array(map, "|", true, true)
    [
      ["id", "inserted_at", "key", "message|schedule_id",
      "message|target|target_domain", "type"],
      [4179, "2018-04-25 14:13:33.469994", "cGhpc2h4fDI5fD", "127", "mydomain.com",
      "email"]
    ]
  """
  def multiple_to_array(map, delimiter \\ "|", convert_nil \\ true, parallel \\ true) do
    temp_data =
      multiple_shrink(map, delimiter, convert_nil, parallel)
    header =
      temp_data
      |> multiple_keys(parallel)
    _data =
      to_array(header, temp_data, convert_nil, parallel)
  end

  @doc """
  Convert deep nested map to flat map.

  ## Examples

    iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}]
    ...>
    iex> shrink_map = TransformMap.multiple_shrink(map, "|", true, true)
    [
      %{
        "id" => 4179,
        "inserted_at" => "2018-04-25 14:13:33.469994",
        "key" => "cGhpc2h4fDI5fD",
        "message|schedule_id" => "127",
        "message|target|target_domain" => "mydomain.com",
        "type" => "email"
      }
    ]
    iex> shrink_map |> List.first() |> Map.get("message|target|target_domain")
    "mydomain.com"

  """
  def multiple_shrink(map, delimiter \\ "|", convert_nil \\ true, parallel \\ true) do
    case parallel do
      true ->
        map
        |> ParallelStream.map(fn x ->
            x
            |> shrink(delimiter, convert_nil, false)
          end)
        |> Enum.into([])
      false ->
        map
        |> Enum.map(fn x ->
          x
          |> shrink(delimiter, convert_nil, false)
        end)
      end
  end

  @doc """
  Convert flat map to deep nested map.

  ## Examples

    iex> shrink_map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message|schedule_id" => "127", "message|target|target_domain" => "mydomain.com", "type" => "email"}]
    ...>
    iex> expand_map = TransformMap.multiple_expand(shrink_map, "|", true)
    [
      %{
        "id" => 4179,
        "inserted_at" => "2018-04-25 14:13:33.469994",
        "key" => "cGhpc2h4fDI5fD",
        "message" => %{
          "schedule_id" => "127",
          "target" => %{"target_domain" => "mydomain.com"}
        },
        "type" => "email"
      }
    ]
    iex> expand_map |> List.first() |> get_in(["message", "target", "target_domain"])
    "mydomain.com"

  """
  def multiple_expand(map, delimiter \\ "|", parallel \\ true) do
    case parallel do
      true ->
        map
        |> ParallelStream.map(fn x ->
          x
          |> expand(delimiter, parallel)
        end)
        |> Enum.into([])
      false ->
        map
        |> Enum.map(fn x ->
          x
          |> expand(delimiter, parallel)
        end)
    end
  end

  defp shrink_parallel(map, delimiter, convert_nil) do
    base_keys =
      map
      |> get_keys()
    all_keys =
      base_keys
      |> ParallelStream.map(fn x ->
        map
        |> single_keys(x, delimiter)
      end)
      |> Enum.into([])
      |> List.flatten()
    _new_map =
      all_keys
      |> ParallelStream.map(fn x ->
        list =
          expand_key(x, delimiter)
        data =
          map
          |> get_in(list)
          |> convert_decimal()
        final_data =
          convert_nil(data, convert_nil)
        _new_map =
          %{
            x => final_data
          }
      end)
      |> Enum.into([])
  end

  defp shrink_normal(map, delimiter, convert_nil) do
    base_keys =
      map
      |> get_keys()
    all_keys =
      base_keys
      |> Enum.map(fn x ->
        map
        |> single_keys(x, delimiter)
      end)
      |> List.flatten()
    _new_map =
      all_keys
      |> Enum.reduce(%{}, fn x, acc ->
        list =
          expand_key(x, delimiter)
        data =
          map
          |> get_in(list)
          |> convert_decimal()
        final_data =
          convert_nil(data, convert_nil)
        new_map =
          %{
            x => final_data
          }
        acc
        |> Map.merge(new_map)
      end)
  end

  defp shrink(map, delimiter, convert_nil, parallel) do
    case parallel do
      true ->
        shrink_parallel(map, delimiter, convert_nil)
      false ->
        shrink_normal(map, delimiter, convert_nil)
    end
  end

  defp expand_list(list, delimiter) do
    list
    |> Enum.reduce([], fn x, acc ->
      value =
        expand_key(x, delimiter)
      _acc =
        [value]
        |> Enum.into(acc)
    end)
  end

  defp middle_entries(list) do
    new =
      list
      |> Enum.reduce([], fn x, acc ->
        value =
          x
          |> List.delete_at(-1)
        _acc =
          [value]
          |> Enum.into(acc)
      end)
      |> Enum.uniq()
      |> Enum.filter(fn x ->
        x != []
      end)
    list
    |> Enum.concat(new)
    |> Enum.sort()
  end

  defp empty_map(list) do
    list
    |> Enum.reduce(%{}, fn x, acc ->
      temp_empty_map =
        acc
        |> put_in(x, %{})
      _acc =
        acc
        |> Map.merge(temp_empty_map)
    end)
  end

  defp expand_normal(map, delimiter) do
    all_keys =
      map
      |> get_keys()
    temp_expanded_list =
      all_keys
      |> expand_list(delimiter)
    expanded_list =
      temp_expanded_list
      |> middle_entries()
    empty_map =
      expanded_list
      |> empty_map()
    _final_map =
      all_keys
      |> Enum.reduce(empty_map, fn x, acc ->
        value =
          map
          |> Map.get(x)
        key =
          expand_key(x, delimiter)
        new_map =
          acc
          |> put_in(key, value)
        acc
        |> Map.merge(new_map)
      end)
  end

  defp expand(map, delimiter, parallel) do
    case parallel do
      true ->
        expand_normal(map, delimiter)
      false ->
        expand_normal(map, delimiter)
    end
  end

  defp expand_key(item, delimiter) do
    check =
      Regex.match?(~r/#{delimiter}/, item)
    _key =
      case check do
        true ->
          item
          |> String.split(delimiter)
        false ->
          [item]
      end
  end

  defp multiple_keys_normal(map) do
    map
    |> Enum.reduce([], fn x, acc ->
      list =
        x
        |> get_keys()
      _acc =
        acc
        |> Enum.concat(list)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp multiple_keys_parallel(map) do
    map
    |> ParallelStream.map(fn x ->
      x
      |> get_keys()
    end)
    |> Enum.into([])
    |> List.flatten()
    |> Enum.uniq()
  end

  @doc """
  Get All Unique Keys from several maps.

  ## Examples

    iex> map = [%{"id" => 4179, "inserted_at" => "2018-04-25 14:13:33.469994", "key" => "cGhpc2h4fDI5fD", "message" => %{"schedule_id" => "127", "target" => %{"target_domain" => "mydomain.com"} }, "type" => "email"}, %{"action" => "open", "data" => %{"accept_language" => "pt", "action_group" => "open", "host" => "host.mydomain.com", "ip" => "127.0.0.1", "method" => "GET", "params" => %{"id" => "cGhpc2h4fDF8MXwx"}}, "referer" => nil, "user_agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "id" => 7, "updated_at" => "2018-04-01 13:52:48.648710", "key" => "cGhpc2h4fDF8MXwxfHJlZ3VsYXJ8MXwx"}]
    ...>
    iex> shrink_map = TransformMap.multiple_shrink(map, "|", true, true)
    ...>
    iex> _all_keys = TransformMap.multiple_keys(shrink_map, true)
    ["id", "inserted_at", "key", "message|schedule_id", "message|target|target_domain", "type", "action", "data|accept_language", "data|action_group", "data|host", "data|ip", "data|method", "data|params|id", "referer", "updated_at", "user_agent"]

  """
  def multiple_keys(map, parallel) do
    case parallel do
      true ->
        multiple_keys_parallel(map)
      false ->
        multiple_keys_normal(map)
    end
  end

  defp get_keys(map) do
    map
    |> Map.keys()
  end

end
