import socket, sys

def connect(address : str, port : int):
    """Method to connect to STK

    Arguments:
    address -- the string ip address (typically localhost or 127.0.0.1)
    port -- the integer port number (typically 5001 is the STK default)
    """
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
    """Method to send command

    Arguements:
    message -- the string message
    s -- the socket connection returned from :meth:`connect` method
    """
    s.sendall(message.encode())

if __name__=="__main__":
    socket = connect()
    sendCmd('ConControl / VerboseOn\n', socket)
    sendCmd('ConControl / AckOn\n', socket)
    sendCmd('New / */Satellite NewSat\n', socket)