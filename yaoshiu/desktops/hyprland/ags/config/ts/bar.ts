const battery = await Service.import('battery')
const systemtray = await Service.import('systemtray')
const network = await Service.import('network')
const hyprland = await Service.import('hyprland')

const ICON_SIZE = 19.2
const DATE_INTERVAL = 1000
const SPACING = 0

const nixos_icon = Widget.Button({
  class_name: 'nixos',
  child: Widget.Label({
    label: '',
  }),
})

const workspaces = Widget.EventBox({
  child: Widget.Box({
    children: hyprland
      .bind('workspaces')
      .as(workspaces =>
        workspaces.map(workspace => Widget.Button({
          class_name: hyprland
            .bind('active')
            .as(active => active.workspace.id === workspace.id ? 'workspace-active' : 'workspace'),
          label: workspace.name,
          on_primary_click: () => hyprland.messageAsync(`dispatch workspace ${workspace.id}`)
        }))
      ),
  }),

  on_scroll_up: () => hyprland.messageAsync('dispatch workspace -1'),
  on_scroll_down: () => hyprland.messageAsync('dispatch workspace +1'),
})

const left = Widget.Box({
  spacing: SPACING,
  hpack: 'start',
  children: [
    nixos_icon,
    workspaces,
  ],
})

const tray = Widget.Box({
  children: systemtray.bind('items').as(
    items => items.map(item =>
      Widget.Button({
        child: Widget.Icon({
          size: ICON_SIZE,
          icon: item.bind('icon')
        }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
      }),
    )
  ),
})

const battery_icon = Widget.Button({
  child: Widget.Icon({
    class_name: 'battery',
    size: ICON_SIZE,
    icon: battery.bind('icon_name')
  }),
})

const network_icon = Widget.Button({
  class_name: 'network',
  child: Widget.Stack({
    children: {
      'wifi': Widget.Icon({
        size: ICON_SIZE,
        icon: network.wifi.bind('icon_name')
      }),
      'wired': Widget.Icon({
        size: ICON_SIZE,
        icon: network.wired.bind('icon_name')
      }),
    },
    shown: network.bind('primary').as(primary => primary || 'wired'),
  })
})

const search_icon = Widget.Button({
  child: Widget.Label({
    label: '',
  }),
})

const date = Variable('', {
  poll: [DATE_INTERVAL, 'date +"%a %b %l:%M %p"'],
})

const time = Widget.Label({
  class_name: 'time',
  label: date.bind(),
})

const right = Widget.Box({
  spacing: SPACING,
  hpack: 'end',
  children: [
    tray,
    battery_icon,
    network_icon,
    search_icon,
    time,
  ]
})

const bar = Widget.CenterBox({
  class_name: 'bar',
  start_widget: left,
  end_widget: right,
})

export default Widget.Window({
  name: 'bar',
  exclusivity: 'exclusive',
  anchor: ['left', 'top', 'right'],
  child: bar
})
