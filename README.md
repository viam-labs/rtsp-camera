Prep linux
===

* sudo apt install libswscale-dev libavcodec-dev libavformat-dev

### Configure your camera

* Start canon `canon -arch arm64` or `canon -arch amd64`
* Install deps `make linux-dep`
* Create golang binary `make build`
* Create appimage `make package`
* Create module tar `make module`

Build for Android
===
* Use android rdk branch `make edit-android`
* Install FFmpeg `make ffmpeg-android`
* Build golang binary `GOOS=android GOARCH=arm64 make build`
* Create module tar `GOOS=android GOARCH=arm64 make module`

Notes
===
* Heavily cribbed from https://github.com/bluenviron/gortsplib/blob/main/examples/client-read-format-h264-convert-to-jpeg/main.go


Sample Config
===
```
{
  "rtsp": "rtsp://username:password@ip:port/path"
}
```

### Attributes

The following attributes are available for `oak-d` cameras:

| Name | Type | Inclusion | Description |
| ---- | ---- | --------- | ----------- |
| `rtsp_address` | string | Required | RTSP server stream URL |

### Supported Codecs

The `rtsp-cam` module supports the following codecs:
- **H.264**
- **H.265**


### Locally installing the module

#### Build

- Start canon `canon -arch arm64` or `canon -arch amd64`
- Install deps `make linux-dep`
- Create golang binary `make build-linux`
- Create appimage `make package`
- Push appiamge to target `TARGET_IP=127.0.0.1 make push-appimage`

#### Configure

```json
  "modules": [
    {
      "executable_path": "/home/viam/viamrtsp-mod",
      "name": "rtsp-mod",
      "type": "local"
    }
  ]

```

## References
- Heavily cribbed from https://github.com/bluenviron/gortsplib
