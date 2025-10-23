var panel = new Panel
var panelScreen = panel.screen

panel.location = "bottom"
panel.hiding = "normal"
panel.offset = 0
panel.floating = false

// For an Icons-Only Task Manager on the bottom, *3 is too much, *2 is too little
// Round down to next highest even number since the Panel size widget only displays
// even numbers
panel.height = 2 * Math.floor(gridUnit * 2.5 / 2)

// Restrict horizontal panel to a maximum size of a 21:9 monitor
const maximumAspectRatio = 21/9;
if (panel.formFactor === "horizontal") {
    const geo = screenGeometry(panelScreen);
    const maximumWidth = Math.ceil(geo.height * maximumAspectRatio);

    if (geo.width > maximumWidth) {
        panel.alignment = "center";
        panel.minimumLength = maximumWidth;
        panel.maximumLength = maximumWidth;
    }
}

panel.addWidget("org.kde.plasma.marginsseparator")
panel.addWidget("org.kde.plasma.showdesktop")

/* ColorScheme switcher */
/*var colorswitcher = panel.addWidget("com.github.heqro.day-night-switcher")
colorswitcher.currentConfigGroup = ["General"]
colorswitcher.writeConfig("iconA", "weather-clear-night-symbolic")
colorswitcher.writeConfig("iconB", "whitebalance-symbolic")
colorswitcher.writeConfig("checked", "true")*/

panel.addWidget("org.kde.plasma.panelspacer")
panel.addWidget("org.kde.plasma.marginsseparator")

/* Vinyl Launcher */
var launcher = panel.addWidget("com.ekaaty.vinyl-launcher")
launcher.currentConfigGroup = ["General"]
launcher.writeConfig("customButtonImage", "start-here-kde")
launcher.writeConfig("displayPosition", "2")

/* Task Manager with icons */
var tm_launchers  = "applications:systemsettings.desktop"
    tm_launchers += ",applications:org.kde.discover.desktop"
    tm_launchers += ",preferred://filemanager"
    tm_launchers += ",preferred://browser"

var taskmanager = panel.addWidget("org.kde.plasma.icontasks")
taskmanager.currentConfigGroup = ["General"];
taskmanager.writeConfig("launchers", tm_launchers);
taskmanager.reloadConfig(); //launchers don't get set unless reloadConfig() is called between writes
taskmanager.writeConfig("separateLaunchers", false);
taskmanager.reloadConfig();

panel.addWidget("org.kde.plasma.panelspacer")
panel.addWidget("org.kde.plasma.systemtray")
panel.addWidget("org.kde.plasma.marginsseparator")

/* Panel clock */
var panel_clock = panel.addWidget("org.kde.plasma.digitalclock")
panel_clock.currentConfigGroup = ["Appearance"]
panel_clock.writeConfig("dateFormat", "custom")
panel_clock.writeConfig("customDateFormat", "dd MMMM")

panel.addWidget("org.kde.plasma.marginsseparator")

