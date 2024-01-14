from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json['message']
    response = generate_response(user_message)
    return jsonify({'response': response})

def generate_response(user_message):
    # Simple logic to respond to user messages
    if "hello" in user_message.lower():
        return "Hello! How can I help you?"
    else:
        return "I am not sure how to respond to that."

if __name__ == '__main__':
    app.run(debug=True)
