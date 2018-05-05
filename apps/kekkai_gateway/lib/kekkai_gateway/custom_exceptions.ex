defimpl Plug.Exception, for: SimpleSchema.FromJsonError do
  def status(_e), do: 422
end
