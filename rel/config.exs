use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :kekkai,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"Qd:k=8`HN{7l7AHTjPzgEja<st@~8j]Dok9wO_!,TKwZJ&9[WuN*97/th>hM]J!$"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"[.4zJChxAD`E4~[9>ILm[O1yf|^1xHi@rl&tH6T%5;Ei<_lUxH<@Tg)fv,oHvmG]"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :kekkai do
  set version: "0.3.1"
  set applications: [
    logger_file_backend: :permanent,
    kekkai_core: :permanent,
    kekkai_gateway: :permanent
  ]
end

