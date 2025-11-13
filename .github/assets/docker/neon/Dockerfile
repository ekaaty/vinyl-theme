FROM invent-registry.kde.org/neon/docker-images/plasma:user
MAINTAINER DeltaCopy
USER root
RUN apt-get update && \
    apt-get dist-upgrade -y --allow-downgrades && \
    apt-get install -y -qq 'cmake' \
          'libkdecorations3-dev' 'libkf6configwidgets-dev' 'libkf6config-dev' 'libkf6coreaddons-dev' \
          'libkf6doctools-dev' 'libkf6style-dev' 'libkf6globalaccel-dev' 'libkf6guiaddons-dev' \
          'libkf6i18n-dev' 'libkf6iconthemes-dev' 'libkf6kcmutils-dev' 'libkf6kio-dev' \
          'libkf6notifications-dev' 'libkf6package-dev' 'libkf6windowsystem-dev' 'libkirigami-dev' \
          'kirigami2-dev' 'kwayland-dev' 'kwin-dev' 'libplasma-dev' 'qt6-base-dev' 'qt6-5compat-dev' \
          'libqt6gui6' 'libqt6uitools6' 'libepoxy-dev' 'build-essential' 'git' 'python3-lxml' \
          'python3-cairosvg' 'x11-apps' 'unzip' && \
    userdel neon
