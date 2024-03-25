# [`rstp` module](https://app.viam.com/module/viam-labs/rtsp-cam)

This module implements the [`"rdk:component:camera"` API](https://docs.viam.com/components/camera/) in an `rstp` model.
With this model, you can configure a streaming camera with an h264 or h265 track for use with Viam.

> [!NOTE]
> For more information, see [Modular Resources](https://docs.viam.com/registry/#modular-resources).
>
> If your streaming camera uses the `x264` streaming video format, use the [`rtsp-h264` camera](https://app.viam.com/module/erh/viamrtsp) instead.

## Requirements

### Prep Linux
* sudo apt install libswscale-dev libavcodec-dev libavformat-dev

### Build for Linux
* Start canon `canon -arch arm64` or `canon -arch amd64`
* Install deps `make linux-dep`
* Create golang binary `make build`
* Create appimage `make package`
* Create module tar `make module`

### Build for Android
* Use android rdk branch `make edit-android`
* Install FFmpeg `make ffmpeg-android`
* Build golang binary `GOOS=android GOARCH=arm64 make build`
* Create module tar `GOOS=android GOARCH=arm64 make module`

## Configure your `rstp` camera

> [!NOTE]
> Before configuring your camera, you must [create a machine](https://docs.viam.com/manage/fleet/machines/#add-a-new-machine).

Navigate to the **Config** tab of your machine's page in [the Viam app](https://app.viam.com).
Click on the **Components** subtab and click **Create component**.
Select the `camera` type, then search for and select the `rtsp` model.
Enter a name for your camera and click **Create**.

On the new component panel, copy and paste the following attribute template into your camera’s **Attributes** box:

```json
{
  "rtsp_address": "<your-rtsp-streaming-address>"
}
```

> [!NOTE]
> For more information, see [Configure a Machine](https://docs.viam.com/manage/configuration/).

### Attributes

| Name | Type | Inclusion | Description |
| ---- | ---- | --------- | ----------- |
| `rtsp_address` | string | **Required** | The RTSP address where the camera streams. |

### Example configuration 

``` json
{
  "components": [
    {
      "name": "camera-1",
      "namespace": "rdk",
      "type": "camera",
      "model": "viam-labs:camera:rtsp",
      "attributes": {
        "rtsp_address": "rtsp://foo:bar@192.168.10.10:554/stream"
      },
      "depends_on": []
    }
  ],
  "modules": [
    {
      "type": "registry",
      "name": "viam-labs_rtsp-cam",
      "module_id": "viam-labs:rtsp-cam",
      "version": "0.0.6"
    }
  ]
}
```

## View the camera stream

Once your camera is configured and connected, go to the **Control** tab in [the Viam app](https://app.viam.com), and click on the camera's dropdown menu.
Then toggle the camera view to ON.
If everything is configured correctly, you will see the live video feed from your camera.
You can change the refresh frequency as needed to change bandwidth.

### Acknowledgements
* Heavily cribbed from https://github.com/bluenviron/gortsplib/blob/main/examples/client-read-format-h264-convert-to-jpeg/main.go

