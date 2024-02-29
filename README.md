# RTSP Camera Module

The `rtsp-cam` module allows you to connect IP Cameras and other RTSP streams to your Viam machine.

:warning: **Module under heavy development and subject to change!**

### Configure your camera

> [!NOTE]  
> Before configuring your camera, you must [create a robot](https://docs.viam.com/manage/fleet/robots/#add-a-new-robot).

Navigate to the **Config** tab of your robot’s page in [the Viam app](https://app.viam.com/).
Click on the **Components** subtab and click **Create component**.
Select the `camera` type, then select the `rtsp-cam` model.
Enter a name for your camera and click **Create**.

On the new component panel, copy and paste the RTSP address into your camera’s **Attributes** box:

```json
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
