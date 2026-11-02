// Serve a compiled web build locally. No packages required.
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const builds = path.join(root, 'output', 'web');
const latest = fs.existsSync(builds) && fs.readdirSync(builds).sort().reverse().find(name =>
    fs.existsSync(path.join(builds, name, 'index.html')) &&
    fs.existsSync(path.join(builds, name, 'game', 'index.html')));
const folder = process.argv[2] ? path.resolve(process.argv[2]) : latest && path.join(builds, latest);
if (!folder) {
    console.error('No successful web build. Run tools/build_web.ps1 first.');
    process.exit(1);
}
const types = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8',
    '.json': 'application/json', '.png': 'image/png', '.ico': 'image/x-icon',
    '.ogg': 'audio/ogg', '.mp3': 'audio/mpeg', '.wav': 'audio/wav', '.wasm': 'application/wasm' };
const server = http.createServer((req, res) => {
    let requested;
    try { requested = decodeURIComponent(new URL(req.url, 'http://localhost').pathname); }
    catch { res.writeHead(400).end(); return; }
    const file = path.resolve(folder, '.' + requested, requested.endsWith('/') ? 'index.html' : '');
    if (!file.startsWith(folder + path.sep)) { res.writeHead(403).end(); return; }
    fs.stat(file, (error, stat) => {
        if (error || !stat.isFile()) { res.writeHead(404).end('Not found'); return; }
        res.writeHead(200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream',
            'Cache-Control': 'no-cache' });
        fs.createReadStream(file).on('error', () => res.destroy()).pipe(res);
    });
});
server.on('error', error => { console.error(error.message); process.exitCode = 1; });
server.listen(8080, '127.0.0.1', () => console.log(`http://127.0.0.1:8080\n${folder}`));
