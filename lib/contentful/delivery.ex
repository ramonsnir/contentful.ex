defmodule Contentful.Delivery do
  @moduledoc """
  A HTTP client for Contentful.
  This module contains the functions to interact with Contentful's read-only
  Content Delivery API.
  It requires the delivery access token to be configured.
  """

  use Contentful.Functions

  @endpoint "cdn.contentful.com"
  @protocol "https"

  def process_url(path), do: "#{@protocol}://#{@endpoint}#{path}"
end
