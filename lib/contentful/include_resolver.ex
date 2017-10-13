defmodule Contentful.IncludeResolver do
  @moduledoc """
  This module contains functions to resolve the includes.
  Later, this module will also have the responsability to make new
  contentful API request to satisfy the missing link to satisfy
  the current missing links if they are not part of the includes.
  """

  def resolve_entry(entries) do
    cond do
      Map.has_key?(entries, "items") ->
        items = entries["items"]
        |> Enum.map(fn entry ->
          resolve_include_field(entry, merge_includes(entries["includes"]))
        end)
        Map.put(entries, "items", items)

      Map.has_key?(entries, "item") ->
        item =
          entries["item"]
          |> resolve_include_field(merge_includes(entries["includes"]))
        Map.put(entries, "item", item)

      true -> entries
    end
  end

  defp merge_includes(includes) do
    case includes do
      nil ->
        []
      _ ->
        Enum.concat(
          Map.get(includes, "Asset", []),
          Map.get(includes, "Entry", [])
        )
    end
  end

  defp resolve_include_field(field, includes) when is_list(field) do
    Enum.map(field, fn field ->
      resolve_include_field(replace_field(field, includes), includes)
    end)
  end
  defp resolve_include_field(field, includes) when is_map(field) do
    field
    |> Map.keys
    |> Enum.map(fn key ->
      {key, replace_field(field[key], includes)}
    end)
    |> Enum.into(%{})
  end
  defp resolve_include_field(field, _includes), do: field

  defp replace_field(field, includes) when is_map(field) do
    case field["sys"] do
      %{"type" => "Link", "linkType" => linkType}
      when linkType in ["Asset", "Entry"] ->
        includes
        |> Enum.find(fn match ->
          match["sys"]["id"] == field["sys"]["id"]
        end)
        |> resolve_include_field(includes)

      _ ->
        resolve_include_field(field, includes)
    end
  end
  defp replace_field(field, includes) do
    resolve_include_field(field, includes)
  end

end
