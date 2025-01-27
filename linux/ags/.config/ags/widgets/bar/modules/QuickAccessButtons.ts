import { bash } from "lib/utils";


const Button = (icon: string, func: () => void) =>
  Widget.Button({
    on_primary_click: func,
    child: Widget.Label({ label: icon }),
  });

export default Widget.Box({
  class_name: "quickaccess-buttons",
  spacing: 15,
  children: [
    Button("", () => App.toggleWindow("wallpapers")),
    Button("", () =>
      bash(`~/.config/hypr/scripts/ScreenShot.sh --area`),
    ),
  ],
});
