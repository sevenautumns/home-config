import re
import os
import sys
import time
import subprocess


class Rofi:
    def __init__(self, args):
        self.args = args

    def select(self, prompt, options, selected):
        items = "\n".join(options)
        ans = os.popen(f"echo '{items}' | rofi -dmenu -i -p '{prompt}' -format i \
      -selected-row {selected} -me-select-entry ''\
      -me-accept-entry 'MousePrimary' {self.args}").read().strip()

        if ans == "":
            return -1

        return int(ans)


class PlayerList:
    def __init__(self):
        self.players = []

    def add_player(self, player):
        self.players.append(player)

    def labels(self):
        list = [p.label for p in self.players]
        return list

    def playing(self):
        playing = []
        for i, player in enumerate(self.players):
            if player.playing:
                playing.append(i)
        return playing

    def name(self, index):
        return self.players[index].name

    def index(self, name):
        for i, player in enumerate(self.players):
            if name == player.name:
                return i
        return -1


class Player:
    def __init__(self, name):
        self.name = name
        label = "[" + name.split(".")[0] + "] "
        status = os.popen(f"playerctl status -p {name}").read().strip()
        metadata = os.popen(f"playerctl metadata -p {name}").read().strip()
        metadata = re.findall(r'^.+(album|artist|title)[^\S\r\n]+(.*)$', metadata, re.M | re.I)
        metadata = dict(filter(lambda data: len(data[1]) > 0, metadata))

        self.title = metadata.get("title")
        self.artist = metadata.get("artist")
        self.album = metadata.get("album")
        if self.title:
            label += self.title
        if self.title and self.artist:
            label += " - "
        if self.artist:
            label += self.artist

        if status == "Playing":
            self.playing = True
        else:
            self.playing = False
        if self.playing:
            label = "(Playing) " + label
        self.label = label


def get_players():
    global playerlist
    playerlist = PlayerList()

    splist = os.popen("playerctl --list-all") \
        .read().strip().split("\n")

    splist.sort()

    for name in splist:
        playerlist.add_player(Player(name))


def show_menu():
    rofi = Rofi("-theme ~/.config/polybar/scripts/rofi/nord.rasi")

    options = []
    options += playerlist.labels()
    options.append("---------")
    options.append("Pause All")
    options.append("Next Track")
    options.append("Prev Track")

    selected = 0
    playing = playerlist.playing()

    if len(playing) > 0:
        selected = playing[0]

    index = rofi.select("Select Player", options, selected)

    if (index == -1):
        return

    if index < len(playerlist.players):
        # If it already plays, just pause it.
        if playerlist.players[index].playing:
            toggleplay(index)
        # Else pause everything else and play this
        else:
            pause_all_except(index)
            toggleplay(index)
    else:
        if options[index] == "Pause All":
            pause_all()
        elif options[index] == "Next Track":
            go_next()
        elif options[index] == "Prev Track":
            go_prev()


def toggleplay(index):
    player = playerlist.players[index]
    if player.playing:
        pause(index)
    else:
        play(index)


def play(index):
    player = playerlist.players[index]
    if not player.playing:
        os.popen(f"playerctl -p {playerlist.name(index)} play").read()


def pause(index):
    player = playerlist.players[index]
    if player.playing:
        os.popen(f"playerctl -p {playerlist.name(index)} pause").read()


def pause_all_except(index):
    for i, _ in enumerate(playerlist.players):
        if i != index:
            pause(i)


def pause_all():
    for i, _ in enumerate(playerlist.players):
        pause(i)


def play_pause():
    playing = False
    for player in playerlist.players:
        if player.playing:
            playing = True
            break

    if playing:
        pause_all()
    else:
        os.popen("playerctl play").read()


def go_next():
    playing = False
    for player in playerlist.players:
        if player.playing:
            playing = True
            os.popen(f"playerctl -p {player.name} next").read()
            return
    if not playing:
        os.popen("playerctl next").read()


def go_prev():
    playing = False
    for player in playerlist.players:
        if player.playing:
            playing = True
            os.popen(f"playerctl -p {player.name} previous").read()
            return
    if not playing:
        os.popen("playerctl previous").read()


def start_autopause():
    p = subprocess.Popen(["playerctl", "status", "--follow", "-f", "autopause - {{playerInstance}} - {{status}}"],
                         stdout=subprocess.PIPE)

    for line in iter(p.stdout.readline, ""):
        item = line.decode('UTF-8').strip()
        if item.startswith("autopause - "):
            split = item.split(" - ")
            name = split[1]
            status = split[2]
            if status == "Playing":
                # This sleep is to avoid conflict
                # When changing players through empris manually
                time.sleep(0.25)
                get_players()
                index = playerlist.index(name)
                if index >= 0:
                    player = playerlist.players[index]
                    if player.playing:
                        pause_all_except(index)


if (__name__ == "__main__"):
    mode = ""

    if len(sys.argv) > 1:
        mode = sys.argv[1]

    if mode == "autopause":
        start_autopause()
    else:
        get_players()
        if mode == "playpause":
            play_pause()
        elif mode == "pauseall":
            pause_all()
        elif mode == "next":
            go_next()
        elif mode == "prev":
            go_prev()
        else:
            show_menu()
