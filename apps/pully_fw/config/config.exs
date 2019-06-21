# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget, :nerves_network],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.

node_name = if Mix.env() == :dev, do: "pully"
interface = if Mix.env() == :prod, do: "wlan0", else: "eth0"
method = if Mix.env() == :prod, do: :dhcpd, else: :dhcp

Logger

config :nerves_init_gadget,
  ifname: interface,
  address_method: method,
  mdns_domain: "nerves.local",
  node_name: node_name,
  node_host: :mdns_domain

config :nerves_network,
  regulatory_domain: "CA"

config :nerves_network, :default,
  wlan0: [
    networks: [
      [
        ssid: "Pully",
        psk: "supersecret",
        key_mgmt: :"WPA-PSK",
        ipv4_address_method: :dhcpd,
        mode: 2
      ]
    ]
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :pully_api, PullyAPIWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "lol_secret_key_base",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: PullyAPIWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

config :phoenix, :json_library, Jason

config :logger, level: :debug

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"
