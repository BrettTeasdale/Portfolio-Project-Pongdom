defmodule Pongdom.Helpers.ResponseParser do
  def get_document(html) do
    Floki.parse_document(html)
  end

  def parse_link_elements(document) do
    for link_element <- Floki.find(document, "link") do
      {_, attributes, _} = link_element

      get_attribute_value(attributes, "href")
    end
  end

  def parse_script_elements(document) do
    for script_element <- Floki.find(document, "script") do
      {_, attributes, _} = script_element

      get_attribute_value(attributes, "src")
    end
  end

  def get_attribute_value(attributes, index) do
    [{_, attribute_value}] = Enum.filter(attributes, fn({attribute_index, _attribute_value}) ->
      if index == attribute_index, do: true, else: false
    end)

    attribute_value
  end
end
