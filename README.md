# STK Engine Container #

 > Unofficial STK Engine on Linux Container

 This requires that you download STK Engine for Linux from [AGI Suppoort](https://support.agi.com/downloads/?t=2) and obtain a license by contacting [AGI Support](mailto:support@agi.com). Once you have obtained these place the STK Engine for Linux zip file and the license file at the root directory of the project.

## Build the image ##

If you would like to build the image yourself

### Example Build Command ###

```docker
docker build . -t jthompson/stkengine
```

## Run the container ##

To run the container

| **Flag** | **Value** |
| :----- | :------ |
| -p, --publish | `8001:8001` |
| -v, --volume | `<local-license-path>:/var/flexlm/stk_server_license.lic` |
| --name | `stk_engine` |

### Example Run Command ###

```docker
docker run --publish 8001:8001 -v <local-license-path>:/app/usr/STK12/Config/stkLicense.lic --name stkengine jthompson/stkengine
```

## Testing ##

Now that the container is running it can be tested utilizing the STK connect api language.  

> [Connect Language Reference](https://help.agi.com/stk/#../Subsystems/connect/Content/theVeryTop.htm)

### Example using python ###

```python
import socket, sys

def connect():
    HOST = 'localhost'
    PORT = 8001
    BUFFER_SIZE = 1024
    s = None

    for res in socket.getaddrinfo(HOST, PORT, socket.AF_INET, socket.SOCK_STREAM):
        af, socktype, proto, canonname, sa = res
        try:
            s = socket.socket(af, socktype, proto)
            s.connect(sa)
        except(socket.error):
            s.close()
            s = None
            continue
        break
    if s is None:
        print('Could not open socket - Please start STK first')
        sys.exit(1)
    return s

def sendCmd(message : str, s : socket):
    s.sendall(message.encode())

if __name__=="__main__":
    socket = connect()
    sendCmd('ConControl / VerboseOn\n', socket)
    sendCmd('ConControl / AckOn\n', socket)
    sendCmd('New / */Satellite NewSat\n', socket)
```
