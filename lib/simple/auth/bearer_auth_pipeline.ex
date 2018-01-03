defmodule Simple.Auth.BearerAuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :simple,
                              module: Simple.Guardian,
                              error_handler: Simple.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
