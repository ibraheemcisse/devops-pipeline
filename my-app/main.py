from flask import Flask, send_from_directory, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return """
    <h1>🚀 DevOps Pipeline App</h1>
    <p>Welcome to the Flask application!</p>
    <p><a href="/dashboard" style="color: #667eea; text-decoration: none; font-weight: bold;">📊 View Pipeline Dashboard</a></p>
    <p><a href="/health" style="color: #10b981; text-decoration: none;">🏥 Health Check</a></p>
    """

@app.route('/dashboard')
def dashboard():
    """Serve the pipeline dashboard"""
    try:
        return send_from_directory('dashboard', 'index.html')
    except FileNotFoundError:
        return """
        <h1>Dashboard Not Found</h1>
        <p>Please make sure dashboard/index.html exists in your project.</p>
        <p><a href="/">← Back to Home</a></p>
        """, 404

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'app': 'devops-pipeline',
        'version': '1.0.0'
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
