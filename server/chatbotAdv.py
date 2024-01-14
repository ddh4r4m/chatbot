from flask import Flask
from flask_socketio import SocketIO, emit
import threading
import time

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your_secret_key'
socketio =  SocketIO(app, cors_allowed_origins="*")

# Global variable to keep track of connected clients
clients = []

@app.route('/')
def index():
    return "Flask WebSocket Server is running"
@socketio.on('connect')
def handle_connect():
    global clients
    clients.append(request.sid)
    print(f"Client connected: {request.sid}")

@socketio.on('disconnect')
def handle_disconnect():
    global clients
    clients.remove(request.sid)
    print(f"Client disconnected: {request.sid}")

@socketio.on('message')
def handle_message(data):
    user_message = data['text']
    response = generate_response(user_message)
    emit('message', {'text': response}, room=request.sid)

def generate_response(user_message):
    # Your chatbot logic goes here
    return "Response to: " + user_message

def background_task():
    while True:
        time.sleep(10)  # Adjust the timing based on your needs
        for client in clients:
            socketio.emit('message', {'text': 'Periodic server message'}, room=client)

if __name__ == '__main__':
    # Run the background task
    threading.Thread(target=background_task, daemon=True).start()
    socketio.run(app, debug=True)
