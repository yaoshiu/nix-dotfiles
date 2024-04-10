import Label from 'types/widgets/label'
import Button from 'types/widgets/button'
import Icon from 'types/widgets/icon'
import { Box } from 'resource:///com/github/Aylur/ags/widgets/box.js'
import Gdk from 'types/@girs/gdk-3.0/gdk-3.0'
import Gtk from 'types/@girs/gtk-3.0/gtk-3.0'

const applications = await Service.import('applications')
const hyprland = await Service.import('hyprland')

const ICON_SIZE = 56

const cache = Utils.readFile(Utils.HOME + '/.local/state/ags/dock.json')

if (!cache) {
  await Utils.execAsync('mkdir -p ' + Utils.HOME + '/.local/state/ags').then(() => {
    Utils.writeFile('[]', Utils.HOME + '/.local/state/ags/dock.json')
  })
}

const pined: string[] = JSON.parse(cache || '[]')

const windows: {
  class: string,
  addrs: string[],
}[] = []

type DockButton = Button<
  Box<Icon<unknown> | Label<unknown>, unknown>,
  { class: string }
>

function DockButton(class_name: string, active: boolean): DockButton {
  return Widget.Button({
    class_name: 'dock-button',
    attribute: {
      class: class_name,
    },
    visible: true,
    child: Widget.Box(
      {
        vertical: true,
        children: [
          Widget.Icon({
            icon: applications.query(class_name)[0]?.icon_name
              || 'application-x-executable',
            size: ICON_SIZE,
          }),
          Widget.Label(active ? '' : '')
        ],
      }
    ),
    on_clicked: (self) => {
      const addr = windows
        .find(({ class: class_name }) => class_name === self.attribute.class)
        ?.addrs[0]

      if (addr === undefined) {
        applications.query(class_name)[0]?.launch()
      }

      hyprland.messageAsync(`dispatch focuswindow address:${addr}`)
    }
  })
}

const dock: Box<
  Box<DockButton, unknown> | Label<unknown>,
  unknown
> = Widget.Box({
  class_name: 'dock',
  children: [
    Widget.Box(pined.map(class_name => DockButton(class_name, false))),
    Widget.Label({
      class_name: 'dock-separator',
      label: '|',
    }),
    Widget.Box()
  ],
  setup: self => {
    hyprland.clients.forEach(client => {
      const entry = windows.find(window => window.class === client.class)

      if (entry) {
        entry.addrs.push(client.address)
      } else {
        windows.push({ class: client.class, addrs: [client.address] })

        if (pined.includes(client.class)) {
          (self.children[0] as Box<DockButton, unknown>).children
            .filter(button => button.attribute.class === client.class)
            .forEach(button =>
              (button.child.children[1] as Label<unknown>)
                .set_label('')
            )
        } else {
          (self.children[2] as Box<DockButton, unknown>)
            .add(DockButton(client.class, true))
        }
      }
    })

    self.hook(hyprland, (self, address: string) => {
      const client = hyprland.getClient(address)

      if (client) {
        const entry = windows.find(window => window.class === client.class)

        if (entry) {
          entry.addrs.push(address)
        } else {
          windows.push({ class: client.class, addrs: [address] })
        }

        const button = self.children
          .flatMap((child => child instanceof Box ? child.children : []))
          .find(child => child.attribute.class === client.class)

        if (button) {
          (button.child.children[1] as Label<unknown>).set_label('')
        } else {
          (self.children[2] as Box<DockButton, unknown>)
            .add(DockButton(client.class, true))
        }
      }
    }, 'client-added')

    self.hook(hyprland, (self, address: string) =>
      windows.forEach(window => {
        window.addrs = window.addrs.filter(addr => addr !== address)

        if (!window.addrs.length) {
          (self.children[0] as Box<DockButton, unknown>)
            .children
            .filter(button => button.attribute.class === window.class)
            .forEach(button =>
              (button.child.children[1] as Label<unknown>).set_label('')
            )

          const button = (self.children[2] as Box<DockButton, unknown>).children
            .find(button => button.attribute.class === window.class)
          button?.destroy()
        }
      })
      , 'client-removed')
  },
})

const dock_revealer = Widget.EventBox({
  class_name: 'dock-revealer',
  child: Widget.Revealer({
    reveal_child: true,
    transition: 'slide_up',
    child: dock,
    margin_top: 10,
  }),
  on_hover: self => {
    self.child.set_reveal_child(true)
  },
  on_hover_lost: self => {
    self.child.set_reveal_child(false)
  },
  margin: 5,
  margin_bottom: 0,
})

export default Widget.Window({
  name: 'dock',
  layer: 'overlay',
  anchor: ['bottom'],
  child: dock_revealer,
})

