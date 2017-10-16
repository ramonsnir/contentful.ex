defmodule Contentful.DeliveryTest do
  use ExUnit.Case
  alias Contentful.Delivery
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @access_token  "ACCESS_TOKEN"
  @space_id      "z3aswf9egfi8"

  setup_all do
    HTTPoison.start
  end

  @tag timeout: 10_000
  test "entries" do
    use_cassette "entries" do
      entries = Delivery.entries(@space_id, @access_token)
      assert is_list(entries)
    end
  end

  @tag timeout: 10_000
  test "search entry with includes" do
    use_cassette "single_entry_with_includes" do
      space_id = "if4k9hkjacuz"
      entries = Delivery.entries(
        space_id, @access_token, %{
          :"fields.slug" => "test-page",
          content_type: "6pFEhaSgDKimyOCE0AKuqe",
          include: 10,
        }
      )
      assert is_list(entries)
    end
  end

  @tag timeout: 10_000
  test "entry" do
    use_cassette "entry" do
      entry = Delivery.entry(@space_id, @access_token, "5JQ715oDQW68k8EiEuKOk8")

      assert is_map(entry.fields)
    end
  end

  test "content_types" do
    use_cassette "content_types" do
      first_content_type = Delivery.content_types(@space_id, @access_token)
      |> Enum.at(0)

      assert is_list(first_content_type.fields)
    end
  end

  test "content_type" do
    use_cassette "content_type" do
      content_type = Delivery.content_type(@space_id, @access_token, "1kUEViTN4EmGiEaaeC6ouY")

      assert is_list(content_type.fields)
    end
  end

  test "assets" do
    use_cassette "assets" do
      first_asset = Delivery.assets(@space_id, @access_token)
      |> Enum.at(0)

      assert is_map(first_asset.fields)
    end
  end

  test "asset" do
    use_cassette "asset" do
      asset = Delivery.asset(@space_id, @access_token, "2ReMHJhXoAcy4AyamgsgwQ")
      fields = asset.fields

      assert is_map(fields)
    end
  end

  test "space" do
    use_cassette "space" do
      space = Delivery.space(@space_id, @access_token)
      locales = space.locales
      |> Enum.at(0)

      assert locales.code == "en-US"
    end
  end
end
