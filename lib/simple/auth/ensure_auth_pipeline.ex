defmodule Simple.Auth.EnsureAuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :simple,
                              module: Simple.Guardian,
                              error_handler: Simple.Auth.ErrorHandler

  plug Guardian.Plug.EnsureAuthenticated
end
