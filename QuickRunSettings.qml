import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "quickRun"

    StyledText {
        width: parent.width
        text: "Quick Run"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StringSetting {
        settingKey: "trigger"
        label: "Trigger"
        description: "Prefix that activates Quick Run in the launcher (e.g. ;, run, >)"
        placeholder: ";"
        defaultValue: ";"
    }

    SliderSetting {
        settingKey: "maxSuggestions"
        label: "Max suggestions"
        description: "How many matching fish functions/abbreviations to show below the literal command"
        defaultValue: 8
        minimum: 1
        maximum: 20
    }
}
