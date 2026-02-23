import Config

config :patriotic_democracy, PatrioticDemocracy.Repo,
  database: "patriotic_democracy_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :patriotic_democracy,
  ecto_repos: [PatrioticDemocracy.Repo]
