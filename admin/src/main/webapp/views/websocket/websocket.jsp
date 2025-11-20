<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .ws-card {
        border-radius: 15px;
        overflow: hidden;
    }

    .ws-card .card-header {
        border-radius: 15px 15px 0 0;
    }

    .ws-alert {
        border-radius: 12px;
    }

    .ws-btn {
        border-radius: 10px;
        padding: 10px 20px;
    }

    .ws-messages {
        border-radius: 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm ws-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-wifi me-2"></i>Web Socket</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Connection Status</h5>
                            <div class="alert alert-info ws-alert">
                                <i class="bi bi-info-circle me-2"></i>WebSocket connection ready
                            </div>
                            <button class="btn btn-success ws-btn" onclick="connectWebSocket()">
                                <i class="bi bi-plug me-2"></i>Connect
                            </button>
                            <button class="btn btn-danger ms-2 ws-btn" onclick="disconnectWebSocket()">
                                <i class="bi bi-plug-fill me-2"></i>Disconnect
                            </button>
                        </div>
                        <div class="col-md-6">
                            <h5>Messages</h5>
                            <div id="websocket-messages" class="border ws-messages p-3" style="height: 300px; overflow-y: auto;">
                                <p class="text-muted">No messages yet...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let ws = null;

    function connectWebSocket() {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        ws = new WebSocket(protocol + '//' + window.location.host + '/ws');

        ws.onopen = function() {
            document.getElementById('websocket-messages').innerHTML =
                '<p class="text-success">Connected to WebSocket server!</p>';
        };

        ws.onmessage = function(event) {
            const messagesDiv = document.getElementById('websocket-messages');
            messagesDiv.innerHTML += '<p>' + event.data + '</p>';
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        };

        ws.onerror = function(error) {
            console.error('WebSocket error:', error);
        };
    }

    function disconnectWebSocket() {
        if (ws) {
            ws.close();
            document.getElementById('websocket-messages').innerHTML =
                '<p class="text-danger">Disconnected from WebSocket server!</p>';
        }
    }
</script>

