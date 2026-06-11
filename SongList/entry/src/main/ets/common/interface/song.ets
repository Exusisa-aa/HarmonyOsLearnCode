interface Song {
    id: number;
    name: string;
    artist: string;
    picture: Resource;
    duration: number;
    audio: Resource;
    sourcePath: string;
}

export default Song;
