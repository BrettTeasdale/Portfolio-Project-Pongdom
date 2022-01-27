defmodule Pongdom.ResponseParserTest do
    use Pongdom.DataCase

    alias Pongdom.Helpers.ResponseParser

    defp get_blank_test_html_document() do
        """
<html>
   <head>
   </head>
   <body>
   </body>
</html>
"""
    end

    defp get_test_html_document() do
        """
<html>
   <head>
      <link rel="stylehseet" href="style.css">
      <link rel="stylehseet" href="style2.css">
      <script src="javascript1.js"></script>
      <script src="javascript2.js"></script>
   </head>
   <body>
   </body>
</html>
"""
    end

    describe "parse_link_elements/1" do
      test "returns empty list when no link elements are present" do
        results = get_blank_test_html_document() |> ResponseParser.get_document |> ResponseParser.parse_link_elements
        assert results = []
      end
  
      test "returns proper link elements elements when present" do
        results = get_test_html_document() |> ResponseParser.get_document |> ResponseParser.parse_link_elements
        assert results = ["style.css", "style2.css"]
      end
    end
  end
  