import os
import sys
import socket
import json
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler

DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class DualStackServer(ThreadingHTTPServer):
    address_family = socket.AF_INET6
    daemon_threads = True

    def server_bind(self):
        try:
            self.socket.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
        except Exception:
            pass
        super().server_bind()

class StudioHandler(SimpleHTTPRequestHandler):
    # Use HTTP/1.0 to ensure clean, instant response completion without connection hangs
    protocol_version = "HTTP/1.0"
    timeout = 10

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def do_POST(self):
        if self.path == '/api/save-index':
            try:
                content_length = int(self.headers.get('Content-Length', 0))
                body = self.rfile.read(content_length).decode('utf-8')
                index_path = os.path.join(DIRECTORY, 'index.html')
                with open(index_path, 'w', encoding='utf-8') as f:
                    f.write(body)
                
                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                response = {
                    'success': True,
                    'message': 'Đã lưu trực tiếp đè vào file index.html',
                    'path': index_path
                }
                self.wfile.write(json.dumps(response, ensure_ascii=False).encode('utf-8'))
            except Exception as e:
                self.send_response(500)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.end_headers()
                self.wfile.write(json.dumps({'success': False, 'error': str(e)}).encode('utf-8'))
        elif self.path == '/api/save-thumbnail':
            try:
                import base64
                content_length = int(self.headers.get('Content-Length', 0))
                raw_body = self.rfile.read(content_length).decode('utf-8')
                payload = json.loads(raw_body)
                b64_str = payload.get('image', '')
                if ',' in b64_str:
                    b64_str = b64_str.split(',', 1)[1]
                data = base64.b64decode(b64_str)
                
                thumb_root = os.path.join(DIRECTORY, 'thumbnail.jpg')
                thumb_images = os.path.join(DIRECTORY, 'images', 'thumbnail.jpg')
                with open(thumb_root, 'wb') as f:
                    f.write(data)
                with open(thumb_images, 'wb') as f:
                    f.write(data)
                
                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                res = {'success': True, 'message': 'Đã lưu ảnh thumbnail.jpg', 'url': '/thumbnail.jpg'}
                self.wfile.write(json.dumps(res, ensure_ascii=False).encode('utf-8'))
            except Exception as e:
                self.send_response(500)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({'success': False, 'error': str(e)}).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def end_headers(self):
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Connection', 'close')
        super().end_headers()

def run(port=3333):
    try:
        server_address = ('::', port)
        httpd = DualStackServer(server_address, StudioHandler)
        print(f"[BIO SERVER] Running dual-stack on port {port} (IPv4 + IPv6)...", flush=True)
    except Exception as e:
        print(f"[BIO SERVER] Dual-stack failed ({e}), falling back to standard IPv4 0.0.0.0...", flush=True)
        server_address = ('0.0.0.0', port)
        from http.server import ThreadingHTTPServer as IPv4Server
        httpd = IPv4Server(server_address, StudioHandler)

    print(f"[BIO SERVER] Available at: http://localhost:{port}/ and http://127.0.0.1:{port}/", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':
    run()
