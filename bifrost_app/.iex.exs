Mix.Config.persist(hex: [
  unsafe_https: true,
  unsafe_registry: true,
  http_options: [ssl: [{:verify, :verify_none}]]
])
