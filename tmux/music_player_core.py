import os
import subprocess
from pyfzf.pyfzf import FzfPrompt
from dataclasses import dataclass
from typing import Optional

Link = str
VideoName = str

MUSIC_PLAYLIST_PATH = "/home/idevtier/vimwiki/home/playlist.md"

@dataclass
class MusicPlaylist:
    data: dict[VideoName, Link]

    def get_video_names(self) -> list[VideoName]:
        return self.data.keys()

    def get_link_by_video_name(self, name: VideoName) -> Optional[Link]:
        if name in self.data:
            return self.data[name]
        return None


def get_music_playlist() -> MusicPlaylist:
    data = {}
    with open(MUSIC_PLAYLIST_PATH, "r") as f:
        for line in f.readlines():
            video_name, link = line.split(" - ")
            data[video_name] = link
    return MusicPlaylist(data)


def main() -> None:
    fzf = FzfPrompt()
    playlist = get_music_playlist()

    video_name = fzf.prompt(playlist.get_video_names(), fzf_options="--border rounded")[0]
    link = playlist.get_link_by_video_name(video_name)

    os.system("clear")
    subprocess.run(["mpv", "--no-video", link])


if __name__ == "__main__":
    main()
