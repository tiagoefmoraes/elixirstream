defmodule Utility.SentryFilter do
  @behaviour Sentry.EventFilter

  def exclude_exception?(%Phoenix.Router.NoRouteError{}, :logger), do: true
  def exclude_exception?(_exception, _source), do: false
end
