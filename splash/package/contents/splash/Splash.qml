import QtQuick
import QtQuick.Controls as Controls
import Qt5Compat.GraphicalEffects
import org.kde.coreaddons as KCoreAddons
import org.kde.kirigami as Kirigami

Rectangle {
    id: root

    //Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    color: Kirigami.Theme.backgroundColor

    property int stage
    property var skin: ""

    property var imgPath: (
        "skins/" + (root.skin ? root.skin : "default") + "/images"
    )

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true;
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: imgPath + "/background"
        fillMode: Image.PreserveAspectCrop
        visible: true

        ColorOverlay {
            anchors.fill: background
            source: background
            color: Kirigami.Theme.highlightColor
            //color: Kirigami.Theme.textColor
            opacity: .15
            visible: false
        }

}

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        KCoreAddons.KUser { id: kuser }


        Image {
            id: animation
            anchors.centerIn: content
            source: imgPath + "/animation.svg"
            //sourceSize.height: size
            //sourceSize.width: size
            sourceSize.height: 320
            sourceSize.width: 320
            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
            }
            smooth: true
            visible: true

            ColorOverlay {
                anchors.fill: animation
                source: animation
                color: Kirigami.Theme.highlightColor
                opacity: 1
            }

        }

        Image {
            id: userAvatar
            source: kuser.faceIconUrl
            anchors.centerIn: parent
            sourceSize.height: animation.height*.75
            sourceSize.width: animation.width*.75
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: maskAvatar
            }
            visible: true

            Rectangle {
                id: holeShadow
                anchors.centerIn: parent
                height: 12
                width: height
                color: Kirigami.Theme.backgroundColor
                radius: 50
                opacity: .75
                visible: false

                Rectangle {
                    id: hole
                    anchors.centerIn: parent
                    height: 8
                    width: height
                    color: Kirigami.Theme.backgroundColor
                    radius: 50
                    opacity: 1
                    visible: false
                }
            }

            Rectangle {
                id: maskAvatar
                height: parent.height*.75
                width: height
                radius: height/2
                visible: false
            }

        }

        Row {
            spacing: Kirigami.Units.largeSpacing
            anchors {
                bottom: animation.bottom
                horizontalCenter: parent.horizontalCenter
                margins: Kirigami.Units.gridUnit
            }

            Text {
                id: welcomeLabel
		/* FIX-ME: For some obscure reason, Ki18n can't translate strings from locale domains
		 * if this widget is installed into user account. This doesn't occurs if LC_MESSAGES
		 * are installed at .local/share/locales or /usr/share/locales. So, I'm using the 
		 * "okular" text-domain for now to resolve the 'Welcome' translation.
		 */
		text: i18nd("okular", "Welcome")
		//text: i18ndc("plasma_lookandfeel_com.ekaaty.vinyl-splash", "@welcomeLabel", "Welcome")
                color: Kirigami.Theme.highlightColor
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pixelSize: 96
                style: Text.Raised; styleColor: Kirigami.Theme.highlightColor
                y: -content.height/2 + height/2
                visible: true

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: kuser.fullName
                    color: Kirigami.Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 32
                    y: parent.height
                    visible: true
                }

            }

        }

    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }

}
