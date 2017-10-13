defmodule Contentful.Preview do
  @moduledoc """
  A HTTP client for Contentful.
  This module contains the functions to interact with Contentful's read-only
  Content Preview API.
  It requires the preview access token to be configured.
  """

  use Contentful.Functions

  @endpoint "preview.contentful.com"
  @protocol "https"

  def process_url(path), do: "#{@protocol}://#{@endpoint}#{path}"
end
