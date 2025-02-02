import Config

{:ok, hostname} = :inet.gethostname()

config :ui, UiWeb.Endpoint,
  url: [host: "#{hostname}.local"],
  http: [port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: "HEY05EB1dFVSu6KykKHuS4rQPQzSHv4F7mGVB/gnDLrIu75wE/ytBXy2TaL3A6RA",
  live_view: [signing_salt: "AAAABjEyERMkxgDh"],
  check_origin: false,
  # Start the server since we're running in a release instead of through `mix`
  server: true,
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ui.PubSub,
  # Nerves root filesystem is read-only, so disable the code reloader
  code_reloader: false

config :ui, Ui.Repo,
  database: "/data/ui/ui.db",
  pool_size: 5,
  show_sensitive_data_on_connection_error: true

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn, init: [:nerves_runtime, :nerves_pack]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger, RamoopsLogger]

# Erlinit can be configured without a rootfs_overlay. See
# https://github.com/nerves-project/erlinit/ for more information on
# configuring erlinit.

# Save a short report on shutdowns just in case it wasn't intentional
config :nerves, :erlinit, shutdown_report: "/data/last_shutdown.txt"

# Advance the timestamp as soon as possible to get the date closer
# to the real one especially on RTC-less devices.
config :nerves, :erlinit, update_clock: true

# Configure the device for SSH IEx prompt access and firmware updates
#
# * See https://hexdocs.pm/nerves_ssh/readme.html for general SSH configuration
# * See https://hexdocs.pm/ssh_subsystem_fwup/readme.html for firmware updates

config :nerves_ssh,
  daemon_option_overrides: [
    {:pwdfun, &NervesLivebook.ssh_check_pass/2},
    {:auth_method_kb_interactive_data, &NervesLivebook.ssh_show_prompt/3}
  ]

config :mdns_lite,
  instance_name: "Nerves Livebook",

  # Use MdnsLite's DNS bridge feature to support mDNS resolution in Erlang
  dns_bridge_enabled: true,
  dns_bridge_port: 53,
  dns_bridge_recursive: false,
  # Respond to "nerves-1234.local` and "nerves.local"
  hosts: [:hostname, "nerves"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      protocol: "http",
      transport: "tcp",
      port: 80
    },
    %{
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]

# Common VintageNet configuration
#
# See bbb.exs, rpi0.exs, etc. for device-specific configuration.
#
# regulatory_domain - 00 (global), change to "US", etc.
# additional_name_servers - Set to try mdns_lite's DNS bridge first
config :vintage_net,
  regulatory_domain: "00",
  additional_name_servers: [{127, 0, 0, 53}]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

import_config "#{Mix.target()}.exs"
