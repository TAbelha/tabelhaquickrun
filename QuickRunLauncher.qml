import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property var pluginService: null
    property string pluginId: "quickRun"
    property string trigger: ";"
    property int maxSuggestions: 8

    readonly property string homeDir: Quickshell.env("HOME") || ""

    property var functionEntries: []
    property var abbrEntries: []

    signal itemsChanged

    Component.onCompleted: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData(pluginId, "trigger", ";");
        maxSuggestions = parseInt(pluginService.loadPluginData(pluginId, "maxSuggestions", "8")) || 8;
    }

    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData(pluginId, "trigger", trigger);
    }

    Process {
        id: functionsProc
        command: ["fish", "-lc", "for f in (functions -n); echo $f (functions -D $f 2>/dev/null); end"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (!line)
                    return;
                const spaceIdx = line.indexOf(" ");
                const name = spaceIdx === -1 ? line : line.substring(0, spaceIdx);
                const path = spaceIdx === -1 ? "" : line.substring(spaceIdx + 1).trim();
                functionEntries.push({
                    name: name,
                    path: path
                });
            }
        }

        onExited: () => root.itemsChanged()
    }

    Process {
        id: abbrProc
        command: ["fish", "-lc", "abbr --show"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                const match = line.match(/^abbr\s+-a\s+--\s+(\S+)\s+(.*)$/);
                if (!match)
                    return;
                let expansion = match[2].trim();
                if (expansion.startsWith("'") && expansion.endsWith("'"))
                    expansion = expansion.slice(1, -1);
                abbrEntries.push({
                    name: match[1],
                    expansion: expansion
                });
            }
        }

        onExited: () => root.itemsChanged()
    }

    function shortenPath(path) {
        if (!path)
            return "";
        if (homeDir && path.startsWith(homeDir))
            return "~" + path.substring(homeDir.length);
        return path;
    }

    function matchScore(candidate, needle) {
        const c = candidate.toLowerCase();
        const n = needle.toLowerCase();
        if (c === n)
            return 0;
        if (c.startsWith(n))
            return 1;
        if (c.includes(n))
            return 2;
        return -1;
    }

    function getItems(query) {
        const text = (query || "").trim();

        if (!text) {
            return [{
                name: "Type a command to run",
                icon: "material:terminal",
                comment: "Runs in a login fish shell — matches your fish functions and abbreviations",
                action: "noop:",
                categories: ["Quick Run"]
            }];
        }

        const items = [{
            name: "Run: " + text,
            icon: "material:terminal",
            comment: "Execute in a login fish shell",
            action: "run:" + text,
            categories: ["Quick Run"]
        }];

        const firstWord = text.split(/\s+/)[0];
        if (firstWord.length > 0 && firstWord === text) {
            const suggestions = [];

            for (const entry of functionEntries) {
                const score = matchScore(entry.name, firstWord);
                if (score >= 0 && entry.name !== firstWord)
                    suggestions.push({
                        score: score,
                        name: entry.name,
                        icon: "material:terminal",
                        comment: "fish function" + (entry.path ? " — " + shortenPath(entry.path) : ""),
                        action: "run:" + entry.name,
                        categories: ["Quick Run"]
                    });
            }

            for (const entry of abbrEntries) {
                const score = matchScore(entry.name, firstWord);
                if (score >= 0 && entry.name !== firstWord)
                    suggestions.push({
                        score: score,
                        name: entry.name,
                        icon: "material:bolt",
                        comment: "fish abbreviation → " + entry.expansion,
                        action: "run:" + entry.expansion,
                        categories: ["Quick Run"]
                    });
            }

            suggestions.sort((a, b) => a.score - b.score || a.name.localeCompare(b.name));
            items.push(...suggestions.slice(0, maxSuggestions));
        }

        return items;
    }

    function executeItem(item) {
        if (!item?.action)
            return;

        const colonIdx = item.action.indexOf(":");
        const actionType = item.action.substring(0, colonIdx);
        const actionData = item.action.substring(colonIdx + 1);

        if (actionType === "run" && actionData)
            Quickshell.execDetached(["fish", "-lc", actionData]);
    }
}
