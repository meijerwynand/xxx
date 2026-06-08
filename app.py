import asyncio
import websockets
from flask import Flask, send_from_directory
import threading

app = Flask(__name__)

# Directory where your static files (HTML, JS, etc.) are located
STATIC_DIR = 'static'

# Set to store connected WebSocket clients
connected_clients = set()

# WebSocket handler
async def handler(websocket):
    # Register the client
    connected_clients.add(websocket)
    try:
        async for message in websocket:
            # Broadcast the message to all connected clients
            disconnected = set()
            for client in connected_clients:
                if client != websocket:
                    try:
                        await client.send(message)
                    except websockets.exceptions.ConnectionClosed:
                        disconnected.add(client)
            connected_clients -= disconnected
    finally:
        # Unregister the client
        connected_clients.discard(websocket)

# Start the WebSocket server
def start_websocket_server():
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    async def main():
        async with websockets.serve(handler, "0.0.0.0", 3001):
            print("WebSocket signaling server is running on port 3001")
            await asyncio.Future()  # Run forever

    loop.run_until_complete(main())

# Flask route to serve the HTML file
@app.route('/')
def index():
    return send_from_directory(STATIC_DIR, 'index.html')

# Flask route to serve static files (CSS, JS, etc.)
@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory(STATIC_DIR, path)

# Start the Flask server
def start_flask_server():
    app.run(host='0.0.0.0', port=5000)
    print("Flask web server is running on port 5000")

if __name__ == '__main__':
    # Start the WebSocket server in a separate thread
    websocket_thread = threading.Thread(target=start_websocket_server)
    websocket_thread.daemon = True
    websocket_thread.start()

    # Start the Flask server
    start_flask_server()