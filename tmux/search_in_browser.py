from collections import defaultdict
import subprocess
import sys
from typing import Optional

from pyfzf.pyfzf import FzfPrompt


Link = str
Browser = str
Query = Link | str


SEARCH_QUERY = "https://duckduckgo.com/?q={query}&t=ffab&ia=web"


class Bookmarks:
    _data: defaultdict[str, Link]

    def __init__(self) -> None:
        self._data = defaultdict(lambda: None)

    def get_link_by_bookmark(self, bookmark: str) -> Optional[Link]:
        return self._data[bookmark]

    def add_bookmark(self, bookmark: str, link: Link) -> None:
        self._data[bookmark] = link

    def get_bookmarks_list(self) -> tuple[str]:
        return tuple(self._data.keys())


def load_bookmarks(bookmarks_path: str) -> Bookmarks:
    bookmarks = Bookmarks()
    with open(bookmarks_path, "r") as f:
        for line in f.readlines():
            name, link = line.replace("\n", "").split(" - ")
            bookmarks.add_bookmark(name, link)
    return bookmarks


def load_query(bookmarks: Bookmarks) -> Query:
    fzf = FzfPrompt()
    result = fzf.prompt(bookmarks.get_bookmarks_list(),
                        fzf_options="--border rounded --print-query")
    if len(result) == 1:
        query = result[0]
        if query.startswith("http"):
            return query
        return SEARCH_QUERY.format(query=query)
    else:
        query = result[1]
        return bookmarks.get_link_by_bookmark(query)


def open_link_in_browser(browser: Browser, query: Query) -> None:
    subprocess.run(["powershell.exe", "/c", "start", f"\"{query}\""])


def main(browser: Browser, bookmarks_path: str) -> None:
    bookmarks = load_bookmarks(bookmarks_path)
    query = load_query(bookmarks)
    open_link_in_browser(browser, query)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Pass browser and path to bookmarks as args")
        exit(1)
    main(sys.argv[1], sys.argv[2])
