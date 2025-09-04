loadTemplate("com.ekaaty.vinyl.desktop.bottomPanel");

const kwinConfig = ConfigFile('kwinrc');
kwinConfig.group = 'Effect-overview';
kwinConfig.writeEntry('BorderActivate', '3'); //overview all desktops bottom-right
